from pydantic import BaseModel
from typing import Optional

class TemplateBase(BaseModel):
    name: str
    html_template: str
    thumbnail_url: Optional[str] = None
    is_public: bool = True

class TemplateCreate(TemplateBase):
    pass

class TemplateResponse(TemplateBase):
    id: int
    
    class Config:
        from_attributes = True
