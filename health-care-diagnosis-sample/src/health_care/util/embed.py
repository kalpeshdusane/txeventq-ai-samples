from PIL import Image
from torchvision.models import resnet50, ResNet50_Weights
import torch
import numpy as np

class Embedding:
  
  weights = ResNet50_Weights.DEFAULT
  model = resnet50(weights=weights)
  model.eval()
  embedding_model = torch.nn.Sequential(*list(model.children())[:-1])
  transform = weights.transforms()

  @classmethod
  def get_embedding(self, img_path:str) -> np.ndarray:
    image = Image.open(img_path).convert("RGB")

    # for greyscale images
    # image = Image.open(img_path).convert("L")
    # image = np.array(image)
    # image = np.stack([image, image, image], axis=-1)
    # image = Image.fromarray(image.astype(np.uint8))

    input_tensor = self.transform(image).unsqueeze(0)
    with torch.no_grad():
      embedding = self.embedding_model(input_tensor).squeeze().numpy()
    embedding = embedding / np.linalg.norm(embedding) # normalize (unit vector)
    return embedding
