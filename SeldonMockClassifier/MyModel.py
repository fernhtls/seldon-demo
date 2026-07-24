import joblib
import numpy as np

"""
Model example for seldon
"""
class MyModel(object):
    """
    Model template. You can load your model parameters in __init__ from a location accessible at runtime
    """

    def __init__(self):
        """
        Add any initialization parameters.
        These will be passed at runtime from the graph definition parameters defined
        in your seldondeployment kubernetes resource manifest.
        On our sample here let's initialize the model.
        """
        print("Initializing ...")
        print("Loading model ...")
        self.model = joblib.load("model.joblib") 
        print("Model Loaded!")

    def __predict_proba(self, X, features_names=None, **kwargs):
        """
        Returns class probabilities.
        Parameters
        ----------
        X : np.ndarray or list[list[float]]
        feature_names : array of feature names (optional)
        """
        print("Predict_proba called")
        X = np.array(X)
        return self.model.predict_proba(X)

    def predict(self, X, features_names=None, **kwargs):
        """
        Returns predictd class labels.
        Parameters
        ----------
        X : np.ndarray or list[list[float]]
        feature_names : array of feature names (optional)
        """
        print("Predict called")
        probs = self.__predict_proba(X)
        labels = self.model.predict(X)
        # combine: label as first column, probabilities appended
        return np.column_stack([labels, probs])

