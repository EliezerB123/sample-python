from flasgger import Schema, fields


class BlenderCommandJSON(Schema):
    data = fields.Str()
