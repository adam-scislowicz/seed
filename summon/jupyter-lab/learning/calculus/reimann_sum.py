# ---
# jupyter:
#   jupytext:
#     cell_metadata_filter: -all
#     custom_cell_magics: kql
#     text_representation:
#       extension: .py
#       format_name: percent
#       format_version: '1.3'
#       jupytext_version: 1.11.2
#   kernelspec:
#     display_name: Python 3.8.10 64-bit
#     language: python
#     name: python3
# ---

# %%
from matplotlib.patches import Rectangle
import matplotlib.pyplot as plt
import numpy as np

nsteps = 50


def valueCubed(val):
    return val**3


fig, ax = plt.subplots()

ax.set(xlim=(-1, 1), xticks=np.arange(-1, 1.2, 0.2), ylim=(-1, 1), yticks=np.arange(-1, 1.2, 0.2))

# quantized x space
xqspc = np.linspace(-1, 1, nsteps)
yvals = valueCubed(xqspc[:, None])


ax.scatter(xqspc, yvals)

for i, x in enumerate(xqspc):
    if x < 0:
        continue
    rect = Rectangle((x, 0), ((1 - (-1)) / nsteps), yvals[i], fill=False)
    ax.add_patch(rect)

plt.axhline(0, color="black", linestyle="--", linewidth=1)
plt.axvline(0, color="black", linestyle="--", linewidth=1)
plt.show()

# %% [markdown]
# # Riemann or Darboux Sums
#
# The reimann sum is a method of integral approximation by finite summation. Don't worry if that
# doesn't make sense yet.
#
# RiemannSum() = $\sum^{n}_{i=1}f(x^*_i)\Delta x_i$
#
# $\Delta x = \frac{b-a}{n}$
#
#

# %%
print("{}, {}".format(xqspc.shape, yvals.shape))

for x in xqspc:
    print("val: {}".format(x))


# %%
def valueCubed(val):
    return val**3
