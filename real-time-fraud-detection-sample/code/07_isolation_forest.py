from sklearn.ensemble import IsolationForest
from sklearn.preprocessing import OneHotEncoder, StandardScaler
from sklearn.pipeline import Pipeline
from sklearn.compose import ColumnTransformer
import pandas as pd
from skl2onnx import to_onnx

def get_svm_model(train_csv_path, save_onnx=False, onnx_path = None):
    train_data = pd.read_csv(train_csv_path)

    categorical_features = ["OPERATION", "DB_USER", "MACHINE_NAME"]
    numeric_features = ["EVENT_HOUR"]

    preprocessor = ColumnTransformer([
        ('cat', OneHotEncoder(handle_unknown='ignore'), categorical_features),
        ('num', StandardScaler(), numeric_features)
    ])

    isolation_forest_model = IsolationForest(contamination=0.07, random_state=42)

    # Build pipeline
    pipeline = Pipeline([
        ('preprocessor', preprocessor),
        ('model', isolation_forest_model)
    ])

    train_input_data = train_data[["EVENT_HOUR", "OPERATION", "DB_USER", "MACHINE_NAME"]]
    # Fit on training data
    pipeline.fit(train_input_data)

    print("Isolation forest trained successfully.")

    if save_onnx:
        example_input = train_input_data[:1]
        # Convert
        onnx_model = to_onnx(pipeline, example_input, target_opset={"": 21, "ai.onnx.ml": 3})
        # Save
        with open(onnx_path, "wb") as f:
            f.write(onnx_model.SerializeToString())
            print(f"Saved ONNX model to {onnx_path}")
        
    return pipeline

def test_pipeline(test_csv_path, pipeline):
    
    test_data = pd.read_csv(test_csv_path)
    test_input_data = test_data[["EVENT_HOUR", "OPERATION", "DB_USER", "MACHINE_NAME"]]

    test_data["predicted_anomaly"]  = pipeline.predict(test_input_data)
    test_data["predicted_anomaly"] = test_data["predicted_anomaly"].map({1: 0, -1: 1})

    return test_data

if __name__ == "__main__":
    csv_path = "../data/train_data.csv"
    onnx_path = "../metadata/isolation_forest.onnx"
    pipeline = get_svm_model(csv_path, True, onnx_path)

    #### Testing on blog sample dataset ####
    csv_path = "../data/test_data_blog.csv"
    test_data = test_pipeline(csv_path, pipeline)
    pd.set_option('display.max_rows', None)
    print("test_data_blog -- \n", test_data)
    pd.reset_option('display.max_rows') 

    #### Testing on test dataset ####
    csv_path = "../data/test_data.csv"
    test_data = test_pipeline(csv_path, pipeline)
    pd.set_option('display.max_rows', None)
    print("test_data -- \n", test_data)
    pd.reset_option('display.max_rows') 



