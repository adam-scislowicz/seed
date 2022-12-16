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

# %% [markdown]
# # Test Update
#
# $$
# \lim_{x \to 1} f(x)
# $$

# %%
from ipywidgets import interactive
from IPython.display import Audio, display
import numpy as np
import matplotlib.pyplot as plt


def beat_freq(f1=220.0, f2=224.0):
    max_time = 3
    rate = 8000
    times = np.linspace(0, max_time, rate * max_time)
    signal = np.sin(2 * np.pi * f1 * times) + np.sin(2 * np.pi * f2 * times)
    display(Audio(data=signal, rate=rate))
    return signal


v = interactive(beat_freq, f1=(200.0, 300.0), f2=(200.0, 300.0))
f1, f2 = v.children[:2]
f1.value = 255
f2.value = 260
plt.plot(v.result[0:6000])

# %%
import numpy as np


class Rect:
    def __init__(self, x, y, w, h):
        self.loc = np.array([x, y])
        self.dim = np.array([w, h])

    def __repr__(self):
        return "(Rect@{},{} {}x{})".format(self.loc[0], self.loc[1], self.dim[0], self.dim[1])


r = Rect(3, 3, 2, 2)

print("{}".format(r))


# %%
