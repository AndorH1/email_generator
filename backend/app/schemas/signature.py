from pydantic import BaseModel
from datetime import datetime
from typing import Dict, Any

class SignatureBase(BaseModel):
    template_id: int
    data: Dict[str, Any]

class SignatureCreate(SignatureBase):
    pass

class SignatureResponse(SignatureBase):
    id: int
    user_id: int
    html_rendered: str
    created_at: datetime
    
    class Config:
        from_attributes = True
