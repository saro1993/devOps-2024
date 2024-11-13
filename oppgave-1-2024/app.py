import base64
import boto3
import json
import os
import random

# Initialize AWS clients
bedrock_client = boto3.client("bedrock-runtime", region_name="us-east-1")
s3_client = boto3.client("s3")

# Environment variables for dynamic configuration
model_id = "amazon.titan-image-generator-v1"
bucket_name = os.environ.get("BUCKET_NAME")  
candidate_number = os.environ.get("CANDIDATE_NUMBER", "default_candidate") 

#lambda function to handel event
def lambda_handler(event, context):
    
    try:
        # Parse the incoming request..
        body = json.loads(event.get("body", "{}"))
        prompt = body.get("prompt", "Default prompt text")
        
        # Generate a unique seed for the image
        seed = random.randint(0, 2147483647)
        s3_image_path = f"{candidate_number}/generated_images/titan_{seed}.png"
        
        # Prepare request to Bedrock model.. 
        native_request = {
            "taskType": "TEXT_IMAGE",
            "textToImageParams": {"text": prompt},
            "imageGenerationConfig": {
                "numberOfImages": 1,
                "quality": "standard",
                "cfgScale": 8.0,
                "height": 1024,
                "width": 1024,
                "seed": seed,
            }
        }
        
        # Invoke the model to generate the image
        response = bedrock_client.invoke_model(modelId=model_id, body=json.dumps(native_request))
        model_response = json.loads(response["body"].read())
        
        # Extract and decode the Base64 image data
        base64_image_data = model_response["images"][0]
        image_data = base64.b64decode(base64_image_data)
        
        # Upload the image data to S3
        s3_client.put_object(Bucket=bucket_name, Key=s3_image_path, Body=image_data)
        
        # Generate S3 URL for the uploaded image
        image_url = f"https://{bucket_name}.s3.amazonaws.com/{s3_image_path}"
        
        return {
            "statusCode": 200,
            "body": json.dumps({"image_url": image_url})
        }
    
    except Exception as e:
        # Return error details for troubleshooting
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
            
        }
