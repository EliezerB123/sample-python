import json, os, uuid
from json import JSONDecodeError

from flask import redirect
from flask import Flask, jsonify, request
from flasgger import Swagger, SwaggerView
from flask_api import status

from schema.command import BlenderCommandJSON

app = Flask(__name__)

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MEDIA_DIR = f"{BASE_DIR}/src/media"

API_VERSION = 1.0
API_SWAGGER_DOCS_URL = f"/api/{API_VERSION}/docs"
swagger_config = Swagger.DEFAULT_CONFIG
swagger_config['swagger_ui_bundle_js'] = '//unpkg.com/swagger-ui-dist@3/swagger-ui-bundle.js'
swagger_config['swagger_ui_standalone_preset_js'] = '//unpkg.com/swagger-ui-dist@3/swagger-ui-standalone-preset.js'
swagger_config['jquery_js'] = '//unpkg.com/jquery@2.2.4/dist/jquery.min.js'
swagger_config['swagger_ui_css'] = '//unpkg.com/swagger-ui-dist@3/swagger-ui.css'
swagger_config['specs_route'] = API_SWAGGER_DOCS_URL
swagger = Swagger(app, config=swagger_config)


class BlenderCommandView(SwaggerView):
    parameters = [
        {
            "name": "data",
            "in": "formData",
            "type": "string",
            "required": True,
        }
    ]
    consumes = ['multipart/form-data']
    responses = {
        200: {
            "description": "Creates a blender command file",
            "schema": BlenderCommandJSON
        }
    }

    def post(self):
        form_data = request.form
        json_data = form_data.get('data')
        if not json_data:
            return jsonify(
                dict(
                    errors=[
                        dict(data="Required parameter")
                    ]
                )
            ), status.HTTP_400_BAD_REQUEST

        try:
            json.loads(json_data)
            file_path = f"{MEDIA_DIR}/{uuid.uuid4()}.json"
            with open(file_path, "w") as json_file:
                json_file.write(json_data)
            return jsonify(dict(file=json_file.name))
        except JSONDecodeError as exc:
            return jsonify(
                dict(
                    errors=[
                        dict(data="Not a valid JSON")
                    ]
                )
            ), status.HTTP_400_BAD_REQUEST


@app.after_request
def after_request(response):
    response.headers.add('Access-Control-Allow-Origin', '*')
    response.headers.add('Access-Control-Allow-Headers', "Authorization, Content-Type")
    response.headers.add('Access-Control-Expose-Headers', "Authorization")
    response.headers.add('Access-Control-Allow-Methods', "GET, POST, PUT, DELETE, OPTIONS")
    response.headers.add('Access-Control-Allow-Credentials', "true")
    response.headers.add('Access-Control-Max-Age', 60 * 60 * 24 * 20)
    return response


view = BlenderCommandView.as_view('blender')
app.add_url_rule('/blender/command/', view_func=view, methods=["POST"])


@app.route("/")
def hello():
    return redirect(API_SWAGGER_DOCS_URL, code=302)


if __name__ == "__main__":
    app.run(debug=True)
    is_media_exists = os.path.exists(MEDIA_DIR)

    if not is_media_exists:
        os.makedirs(is_media_exists)
