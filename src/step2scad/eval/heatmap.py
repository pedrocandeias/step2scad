"""Stage 5c: HEATMAP + SWEEP PLOTS — the diagnostic images per iteration.

    render_heatmap       paint per-vertex recon->reference surface distance
                         onto the recon mesh and render it from several angles
                         (matplotlib Agg, headless-safe) with a colour scale;
                         also export a vertex-coloured .ply for human viewing
    plot_section_sweeps  recon-area vs reference-area curves per axis with the
                         divergence shaded (reads localized.py sweep output)

These are the ONE set of images worth producing per emit/eval iteration: they
show *where* the reconstruction is wrong, not just that it is.
"""

from __future__ import annotations

from pathlib import Path

import matplotlib
import numpy as np
import trimesh

matplotlib.use("Agg")  # headless-safe; must precede pyplot import
import matplotlib.pyplot as plt  # noqa: E402

# (elevation, azimuth): two opposite iso quarters, near-top, and from below
# (the below view is what exposes bottom-face features like bore chamfers)
_VIEWS = ((30, 45), (30, 225), (75, 0), (-40, 45))
_CMAP = "inferno"


def render_heatmap(
    recon: trimesh.Trimesh,
    vertex_distances: np.ndarray,
    out_png: Path,
    out_ply: Path | None = None,
    title: str = "recon -> reference surface distance",
) -> dict:
    """Render the surface-distance heatmap PNG (+ optional vertex-colour PLY).

    `vertex_distances` is per-recon-vertex (from eval.localized.surface_distance).
    Returns {png, ply, max, mean} so callers can log the scale.
    """
    d = np.asarray(vertex_distances, dtype=float)
    vmax = float(d.max()) if d.max() > 0 else 1.0
    norm = matplotlib.colors.Normalize(vmin=0.0, vmax=vmax)
    cmap = matplotlib.colormaps[_CMAP]

    # face colour = mean of its vertex distances
    face_d = d[recon.faces].mean(axis=1)

    fig = plt.figure(figsize=(5 * len(_VIEWS), 5.4))
    tri = recon.vertices[recon.faces]  # (n, 3, 3)
    for i, (elev, azim) in enumerate(_VIEWS):
        ax = fig.add_subplot(1, len(_VIEWS), i + 1, projection="3d")
        coll = ax.plot_trisurf(
            recon.vertices[:, 0],
            recon.vertices[:, 1],
            recon.vertices[:, 2],
            triangles=recon.faces,
            linewidth=0.0,
            antialiased=False,
        )
        coll.set_facecolors(cmap(norm(face_d)))
        # equal aspect so the geometry isn't distorted
        span = recon.extents.max()
        mid = recon.bounds.mean(axis=0)
        ax.set_xlim(mid[0] - span / 2, mid[0] + span / 2)
        ax.set_ylim(mid[1] - span / 2, mid[1] + span / 2)
        ax.set_zlim(mid[2] - span / 2, mid[2] + span / 2)
        ax.set_box_aspect((1, 1, 1))
        ax.view_init(elev=elev, azim=azim)
        ax.set_title(f"elev {elev}°, azim {azim}°", fontsize=9)
        ax.set_xlabel("x")
        ax.set_ylabel("y")
        ax.set_zlabel("z")
    fig.suptitle(f"{title}  (max {d.max():.3f} mm, mean {d.mean():.3f} mm)")
    mappable = matplotlib.cm.ScalarMappable(norm=norm, cmap=cmap)
    fig.colorbar(
        mappable, ax=fig.axes, shrink=0.6, pad=0.02, label="distance to reference (mm)"
    )
    out_png.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(out_png, dpi=110)
    plt.close(fig)

    ply_path = None
    if out_ply is not None:
        colored = recon.copy()
        colored.visual.vertex_colors = (cmap(norm(d)) * 255).astype(np.uint8)
        colored.export(out_ply)
        ply_path = str(out_ply)

    return {
        "png": str(out_png),
        "ply": ply_path,
        "max": round(float(d.max()), 4),
        "mean": round(float(d.mean()), 4),
    }


def plot_section_sweeps(sweeps: dict, out_png: Path) -> Path:
    """One PNG: per-axis recon vs reference section-area curves, divergence
    shaded (red = recon surplus / false positive, blue = deficit / missing)."""
    fig, axs = plt.subplots(1, 3, figsize=(15, 4.2), sharey=False)
    for ax_plot, (name, sw) in zip(axs, sweeps.items()):
        c = np.array(sw["coords"])
        ra = np.nan_to_num(np.array(sw["recon_area"]), nan=0.0)
        fa = np.nan_to_num(np.array(sw["reference_area"]), nan=0.0)
        ax_plot.plot(c, fa, label="reference", color="black", lw=1.5)
        ax_plot.plot(c, ra, label="recon", color="tab:orange", lw=1.2)
        ax_plot.fill_between(
            c, ra, fa, where=ra > fa, color="tab:red", alpha=0.35,
            label="surplus (FP)",
        )
        ax_plot.fill_between(
            c, ra, fa, where=ra < fa, color="tab:blue", alpha=0.35,
            label="deficit (FN)",
        )
        worst = sw["max_abs_diff"]
        ax_plot.axvline(worst["coord"], color="gray", ls="--", lw=0.8)
        ax_plot.set_title(
            f"{name.upper()} sweep — worst @ {worst['coord']:.2f} "
            f"({worst['diff']:+.1f} mm²)",
            fontsize=10,
        )
        ax_plot.set_xlabel(f"{name} (mm)")
        ax_plot.set_ylabel("section area (mm²)")
        ax_plot.legend(fontsize=8)
    fig.suptitle("cross-section area: recon vs reference")
    fig.tight_layout()
    out_png.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(out_png, dpi=110)
    plt.close(fig)
    return out_png
