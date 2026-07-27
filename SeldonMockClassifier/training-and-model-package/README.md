# The model: LogisticRegression on the Iris dataset

## What it's doing

Despite the name, logistic regression is a classification algorithm, not regression — it predicts discrete categories, not continuous values. The Iris dataset has 3 flower species (setosa, versicolor, virginica), and the model learns to distinguish between them based on 4 measured features per flower:

* Sepal length
* Sepal width
* Petal length
* Petal width

How it works, conceptually:
For each class, the model learns a set of weights (coefficients) — one per feature — plus a bias term. It computes a weighted sum of the input features, then passes that through a softmax function (for multi-class problems like this one) to turn raw scores into probabilities that sum to 1 across the 3 classes. Whichever class gets the highest probability is the predicted label.

So under the hood, model.predict([[5.1, 3.5, 1.4, 0.2]]) is really doing something like:

score_setosa     = w1·5.1 + w2·3.5 + w3·1.4 + w4·0.2 + b1
score_versicolor = w1·5.1 + w2·3.5 + w3·1.4 + w4·0.2 + b2
score_virginica  = w1·5.1 + w2·3.5 + w3·1.4 + w4·0.2 + b3
→ softmax(scores) → pick highest probability

(with separate weight vectors per class)

## Why it's a good "hello world" model

Linearly separable-ish data — Iris is famously easy to classify, so accuracy is typically 95%+ even with minimal tuning
Fast to train (milliseconds), small model artifact, no GPU needed
predict() and predict_proba() both work out of the box, useful for testing both output modes in Seldon

max_iter=200 in the training script just raises the cap on optimizer iterations (logistic regression is fit via iterative solvers like lbfgs by default) — the default of 100 sometimes doesn't converge on this dataset, so bumping it avoids a ConvergenceWarning.

## What the saved model.joblib actually contains

Just the learned weight matrix, bias terms, and class labels — nothing about the training data itself. That's what makes it small (a few KB) and fast to load in the Seldon sklearn server at inference time.
