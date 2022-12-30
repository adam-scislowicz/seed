# ---
# jupyter:
#   jupytext:
#     cell_metadata_filter: -all
#     custom_cell_magics: kql
#     text_representation:
#       extension: .py
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.14.4
#   kernelspec:
#     display_name: Python 3.10.6 64-bit
#     language: python
#     name: python3
# ---

import torch
print(torch.__version__)
x = torch.rand(2, 3)
print(x)

# +
from matplotlib.patches import Rectangle
import matplotlib.pyplot as plt
import numpy as np

nsteps = 50

def loss_y_zero(val):
    return -1*np.log(1-val)


def loss_y_one(val):
    return -1*np.log(val)

fig, ax = plt.subplots()

ax.set(xlim=(0, 1), xticks=np.arange(0, 1.2, 0.2), ylim=(0, 3), yticks=np.arange(0, 3.2, 0.2))

# quantized x space
xqspc = np.linspace(0.001, 0.999, nsteps) # avoid log(0)
y0vals = loss_y_zero(xqspc[:, None])
y1vals = loss_y_one(xqspc[:, None])


ax.scatter(xqspc, y0vals)
ax.scatter(xqspc, y1vals)

#plt.axhline(0, color="black", linestyle="--", linewidth=1)
#plt.axvline(0, color="black", linestyle="--", linewidth=1)
plt.title('Logistic loss aka cross-entropy loss:\n$ l(y, \sigma(z)) = -ylog(\sigma(z)-(1-y)log(1-\sigma(z))) $')
plt.xlabel('$ \sigma(z) $')
plt.ylabel('$ l(y, \sigma(z)) $')
plt.show()
# -

#
# ### Models discussed thus far:
#
# - Logistic regression
# - Multilayer Perceptron
# - Convolutional Neural Network (CNN)
#
# ### Concepts related to Model Evaluation
#
# **Overfitting**
# A model may fit the training set well, but not perform well on future data. In this case, it may be overfitting. Check the following to see if that may be the case:
#
# 1. Increasing parameters increases error rate.
# 1. Complex relationship may be too complex for reality.
# 1. Models and analysis are not generalizable.
#
# ### Data Utilization
#
# Split data that you have into training, validation, and testing data sets. Best practices depend on the size of the data set and other complex properties of the model and data.
#
# The training data set will be used to determine the model parameters.
#
# The testing set will never be used to learn or fit any parameters, and can be used to evaluate the performance of a parameterized model. The testing set will only be used once to avoid bias making us over-confident in our selected model.
#
# The validation set, like the testing set will not be used to learn parameters. The validation set, unlike the testing set will be used multiple times to estimate the performance of a model. The estimated performance will be used to select a model.
#
# After selecting a model using the validation set the testing set will be used once to estimate real-world performance.
#
#
