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
#     display_name: Python 3.10.6 64-bit
#     language: python
#     name: python3
# ---

# %%
import torch

# %%
print(torch.__version__)
x = torch.rand(2, 3)
print(x)

# %%
from matplotlib.patches import Rectangle
import matplotlib.pyplot as plt
import numpy as np

nsteps = 50


def loss_y_zero(val):
    return -1 * np.log(1 - val)


def loss_y_one(val):
    return -1 * np.log(val)


fig, ax = plt.subplots()

ax.set(xlim=(0, 1), xticks=np.arange(0, 1.2, 0.2), ylim=(0, 3), yticks=np.arange(0, 3.2, 0.2))

# quantized x space
xqspc = np.linspace(0.001, 0.999, nsteps)  # avoid log(0)
y0vals = loss_y_zero(xqspc[:, None])
y1vals = loss_y_one(xqspc[:, None])


ax.scatter(xqspc, y0vals)
ax.scatter(xqspc, y1vals)

# plt.axhline(0, color="black", linestyle="--", linewidth=1)
# plt.axvline(0, color="black", linestyle="--", linewidth=1)
plt.title(
    "Logistic loss aka cross-entropy loss:\n$ l(y, \sigma(z)) = -ylog(\sigma(z)-(1-y)log(1-\sigma(z))) $"
)
plt.xlabel("$ \sigma(z) $")
plt.ylabel("$ l(y, \sigma(z)) $")
plt.show()

# %% [markdown]
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

# %% [markdown]
# ## Learning via Gradient Descent
#
# See the plot below for a simple 1D example. Here you can imagine gradient descent as taking step-size movements towards the local minimum. If the step size is not correct for the scale of the local features it may step over the local minimum. If the step size is too small it may take too many steps to reach the local minimum. Step size will be called $ \alpha^k $
#
# Calculate the slope at the current point. For one parameter this can be done using a derivative. For more parameters the general form of the equation is $ \nabla f(b^k) $
#
# This will give us an update function: $ b^{k+1} \leftarrow b^k - a^k \nabla f(b^k) $
#
# Remember the cost function (avg loss) looks similar to the following: $ b^* = arg\ min_b \frac{1}{N} \sum_i^N l(y_i, \sigma(z^i)) $
#
# Gradient descent vs Stochastic gradient descent. Using 1 or a much smaller number of randomly selected samples per iteration rather than the entire training set.
#
# Early stopping involves utilizing the validation set during training and deciding to stop when improvements to the performance on the validation set is no longer improving. This can avoid over-fitting.
#
# Concepts:
#
# - Mini-batching
# - Gradient Descent
# - Stochastic Gradient Descent
# - Early Stopping
#

# %%
from matplotlib.patches import Rectangle
import matplotlib.pyplot as plt
import numpy as np

nsteps = 50


def simple_function(val):
    return 1 + np.power(val, 2)


fig, ax = plt.subplots()

ax.set(xlim=(-2, 2), xticks=np.arange(-2, 2.1, 1), ylim=(0, 4), yticks=np.arange(0, 4.1, 1))

# quantized x space
xqspc = np.linspace(-1.999, 1.999, nsteps)  # avoid log(0)
y0vals = simple_function(xqspc[:, None])
xval = 1.5
yval = simple_function(xval)

ax.plot(xqspc, y0vals)
ax.scatter(xval, yval)

plt.axhline(0, color="black", linestyle="--", linewidth=1)
plt.axvline(0, color="black", linestyle="--", linewidth=1)
plt.title("Gradient Descent of a Simple Function")
plt.xlabel("$ b $")
plt.ylabel("$ f(b) $")
plt.show()

# %%
# Lab 2A_Logistic_Regression
# This is sample code, utilizing the nn.Module class.

import numpy as np
import torch
import torch.nn as nn
import torch.nn.functional as F
from torchvision import datasets, transforms
from tqdm.notebook import tqdm


class MNIST_Logistic_Regression(nn.Module):
    def __init__(self):
        super().__init__()
        self.lin = nn.Linear(784, 10)

    def forward(self, x):
        return self.lin(x)


# Load the data
mnist_train = datasets.MNIST(
    root="./datasets", train=True, transform=transforms.ToTensor(), download=True
)
mnist_test = datasets.MNIST(
    root="./datasets", train=False, transform=transforms.ToTensor(), download=True
)
train_loader = torch.utils.data.DataLoader(mnist_train, batch_size=100, shuffle=True)
test_loader = torch.utils.data.DataLoader(mnist_test, batch_size=100, shuffle=False)

## Training
# Instantiate model
model = MNIST_Logistic_Regression()

# Loss and Optimizer
criterion = nn.CrossEntropyLoss()
optimizer = torch.optim.SGD(model.parameters(), lr=0.1)

# Iterate through train set minibatchs
for images, labels in tqdm(train_loader):
    # Zero out the gradients
    optimizer.zero_grad()

    # Forward pass
    x = images.view(-1, 28 * 28)
    y = model(x)
    loss = criterion(y, labels)
    # Backward pass
    loss.backward()
    optimizer.step()

## Testing
correct = 0
total = len(mnist_test)

with torch.no_grad():
    # Iterate through test set minibatchs
    for images, labels in tqdm(test_loader):
        # Forward pass
        x = images.view(-1, 28 * 28)
        y = model(x)

        predictions = torch.argmax(y, dim=1)
        correct += torch.sum((predictions == labels).float())

print("Test accuracy: {}".format(correct / total))

# %%
# Lab 2B_MultiLayer_Perceptron_Assignment

import numpy as np
import matplotlib.pyplot as plt
import torch
import torch.nn as nn
import torch.nn.functional as F
from torchvision import datasets, transforms
from tqdm.notebook import tqdm
import random

random.seed(0)  # make PSRN reproducible

mnist_train = datasets.MNIST(
    root="./datasets", train=True, transform=transforms.ToTensor(), download=True
)
mnist_test = datasets.MNIST(
    root="./datasets", train=False, transform=transforms.ToTensor(), download=True
)

mnist_train_n = len(mnist_train)
mnist_test_n = len(mnist_test)

print("DEBUG: Number of MNIST training examples: {}".format(mnist_train_n))
print("DEBUG: Number of MNIST test examples: {}".format(mnist_test_n))


# Pick some random examples to get a feel for the data: Show some images and pixel value histograms
n_samples = 4
fig, ax = plt.subplots(2, n_samples, figsize=(20, 5))
for i in range(n_samples):
    randidx = random.randrange(0, mnist_train_n)
    image, label = mnist_train[randidx]
    image = image.reshape([28, 28])
    print("DEBUG: mnist_train[{}]: {} -> {}".format(randidx, image.shape, label))
    ax[0, i].imshow(image.view(28, 28), cmap="gray")

    bins = 20
    hist = torch.histc(image, bins=bins, min=0, max=1)
    x = range(bins)
    ax[1, i].bar(x, hist, align="center")
    ax[1, i].set_title("histogram")
    ax[1, i].set_yscale("log")
fig.tight_layout()

# Setup a loader to handle minibatching
train_loader = torch.utils.data.DataLoader(mnist_train, batch_size=100, shuffle=True)
test_loader = torch.utils.data.DataLoader(mnist_test, batch_size=100, shuffle=False)

# Get data one mini-batch at a time
# data_train_iter = iter(train_loader)
# images, labels = data_train_iter.next()

W1 = torch.randn(784, 500) / np.sqrt(784)
W1.requires_grad_()
W2 = torch.randn(500, 10) / np.sqrt(500)
W2.requires_grad_()
print("DEBUG: W1.shape: {}".format(W1.shape))
print("DEBUG: W2.shape: {}".format(W2.shape))

optimizer = torch.optim.SGD([W1, W2], lr=0.1)

for images, labels in tqdm(train_loader):
    optimizer.zero_grad()

    # Forward pass
    x = images.view(-1, 28 * 28)
    w1o = F.relu(torch.matmul(x, W1))
    y = torch.matmul(w1o, W2)

    cross_entropy = F.cross_entropy(y, labels)

    # Backward pass
    cross_entropy.backward()
    optimizer.step()


# %%
# Lab 2B Multilayer Perceptron Using nn.Module
import numpy as np
import torch
import torch.nn as nn
import torch.nn.functional as F
from torchvision import datasets, transforms
from tqdm.notebook import tqdm


class MNIST_Multilayer_Perceptron(nn.Module):
    def __init__(self):
        super().__init__()
        self.fc1 = nn.Linear(784, 500)
        self.fc2 = nn.Linear(500, 10)

    def forward(self, x):
        x = x.view(-1, 28 * 28) # in-place reshape
        x = F.relu(self.fc1(x))
        return self.fc2(x)


# Load the data
mnist_train = datasets.MNIST(
    root="./datasets", train=True, transform=transforms.ToTensor(), download=True
)
mnist_test = datasets.MNIST(
    root="./datasets", train=False, transform=transforms.ToTensor(), download=True
)
train_loader = torch.utils.data.DataLoader(mnist_train, batch_size=100, shuffle=True)
test_loader = torch.utils.data.DataLoader(mnist_test, batch_size=100, shuffle=False)

## Training
# Instantiate model
model = MNIST_Multilayer_Perceptron()

# Loss and Optimizer
criterion = nn.CrossEntropyLoss()
optimizer = torch.optim.SGD(model.parameters(), lr=0.1)

# Iterate through train set minibatchs
for images, labels in tqdm(train_loader):
    # Zero out the gradients
    optimizer.zero_grad()

    # Forward pass
    x = images
    y = model(x)
    loss = criterion(y, labels)
    # Backward pass
    loss.backward()
    optimizer.step()

## Testing
correct = 0
total = len(mnist_test)

with torch.no_grad():
    # Iterate through test set minibatchs
    for images, labels in tqdm(test_loader):
        # Forward pass
        x = images
        y = model(x)

        predictions = torch.argmax(y, dim=1)
        correct += torch.sum((predictions == labels).float())

print(model)
print("Test accuracy: {}".format(correct / total))
