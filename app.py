from flask import Flask, request, jsonify
from flask_cors import CORS
from diffusers import StableDiffusionPipeline
import torch
from PIL import Image
import base64
import io
import os
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)
CORS(app)

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
        logger.info(f"Initialized generator with device: {device}")

    def load_model(self, model_name):
        try:
            if model_name not in MODEL_PATHS:
                raise ValueError(f"Model '{model_name}' not available.")

            if model_name in self.models:
                return self.models[model_name]

            logger.info(f"Loading model: {model_name}")
            
            pipe = StableDiffusionPipeline.from_pretrained(
                MODEL_PATHS[model_name], 
                torch_dtype=torch.float32
            )
            pipe = pipe.to(self.device)
            
            self.models[model_name] = pipe
            return pipe
        except Exception as e:
            logger.error(f"Error loading model {model_name}: {str(e)}")
            raise

    def generate_image(self, prompt, model_name="stable_diffusion_v1_5", width=512, height=512):
        try:
            pipe = self.load_model(model_name)
            
            image = pipe(
                prompt=prompt,
                width=width,
                height=height,
                num_inference_steps=30,
            ).images[0]
            
            return image
        except Exception as e:
            logger.error(f"Error generating image: {str(e)}")
            raise

    def image_to_base64(self, image):
        try:
            buffer = io.BytesIO()
            image.save(buffer, format="PNG")
            return base64.b64encode(buffer.getvalue()).decode("utf-8")
        except Exception as e:
            logger.error(f"Error converting image to base64: {str(e)}")
            raise

# Initialize the generator
generator = MultiModelImageGenerator()

@app.route('/', methods=['GET'])
def home():
    return jsonify({
        'status': 'running',
        'available_endpoints': [
            '/generate_image',
            '/available_models'
        ]
    })

@app.route('/generate_image', methods=['POST'])
def generate_image():
    try:
        data = request.get_json()
        if not data:
            return jsonify({'error': 'No JSON data received'}), 400

        prompt = data.get('prompt')
        model_name = data.get('model_name', 'stable_diffusion_v1_5')
        width = data.get('width', 512)
        height = data.get('height', 512)

        if not prompt:
            return jsonify({'error': 'Prompt is required'}), 400

        logger.info(f"Generating image with prompt: {prompt}, model: {model_name}")

        # Generate image
        image = generator.generate_image(prompt, model_name, width, height)
        
        # Convert to base64
        image_base64 = generator.image_to_base64(image)

        return jsonify({
            'success': True,
            'image': image_base64,
            'model_used': model_name
        })

    except Exception as e:
        logger.error(f"Error in generate_image endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.route('/available_models', methods=['GET'])
def get_available_models():
    try:
        return jsonify({
            'success': True,
            'models': list(MODEL_PATHS.keys())
        })
    except Exception as e:
        logger.error(f"Error in available_models endpoint: {str(e)}")
        return jsonify({'error': str(e)}), 500

@app.errorhandler(404)
def not_found(e):
    return jsonify({'error': 'Route not found'}), 404

@app.errorhandler(500)
def server_error(e):
    return jsonify({'error': 'Server error occurred'}), 500

if __name__ == '__main__':
    try:
        logger.info("Starting Flask server...")
        app.run(host='0.0.0.0', port=5000, debug=True)
    except Exception as e:
        logger.error(f"Failed to start server: {str(e)}")