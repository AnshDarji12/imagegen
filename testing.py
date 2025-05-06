from diffusers import StableDiffusionPipeline
import torch
from PIL import Image
import base64
import io
import os

# Available models and their Hugging Face paths
MODEL_PATHS = {
    "stable_diffusion_v1_5": "runwayml/stable-diffusion-v1-5",
    "openjourney": "prompthero/openjourney",
    "dreamshaper": "Lykon/DreamShaper",
    "dreamlike_photoreal": "dreamlike-art/dreamlike-photoreal-2.0",
    "waifu_diffusion": "hakurei/waifu-diffusion"
}

class MultiModelImageGenerator:
    def __init__(self, device="cuda" if torch.cuda.is_available() else "cpu"):
        self.device = device
        self.models = {}

    def load_model(self, model_name):
        if model_name not in MODEL_PATHS:
            raise ValueError(f"Model '{model_name}' not available.")

        if model_name in self.models:
            return self.models[model_name]

        print(f"Loading model: {model_name}")
        
        # Simply use the basic approach that works for you
        pipe = StableDiffusionPipeline.from_pretrained(
            MODEL_PATHS[model_name], 
            torch_dtype=torch.float32
        )
        pipe = pipe.to(self.device)
        
        # Store the model
        self.models[model_name] = pipe
        return pipe

    def generate_image(self, prompt, model_name="stable_diffusion_v1_5", width=512, height=512):
        pipe = self.load_model(model_name)
        
        # Use the simple approach that works for you
        image = pipe(
            prompt=prompt,
            width=width,
            height=height,
            num_inference_steps=30,
        ).images[0]
        
        return image

    def save_image(self, image, path="generated_image.png"):
        image.save(path)
        print(f"Image saved at {path}")

    def image_to_base64(self, image):
        buffer = io.BytesIO()
        image.save(buffer, format="PNG")
        return base64.b64encode(buffer.getvalue()).decode("utf-8")

if __name__ == "__main__":
    generator = MultiModelImageGenerator()

    # Test with different models
    prompts_and_models = [
        ("a photo of an astronaut riding a horse on mars", "dreamlike_photoreal"),
        ("a futuristic cityscape at night, vibrant neon colors", "dreamlike_photoreal"),
        # Uncomment to test other models
        # ("a beautiful digital painting of a peaceful meadow", "dreamshaper"),
        # ("a cyberpunk character portrait", "openjourney")
    ]
    
    for i, (prompt, model) in enumerate(prompts_and_models):
        print(f"Generating image {i+1} with model: {model}")
        image = generator.generate_image(prompt, model_name=model)
        generator.save_image(image, f"{model}_{i+1}.png")