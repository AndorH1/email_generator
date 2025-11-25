from pydantic import BaseModel
from typing import Optional

class ProfileBase(BaseModel):
    job_title: Optional[str] = None
    phone: Optional[str] = None
    website: Optional[str] = None
    avatar_url: Optional[str] = None

class ProfileCreate(ProfileBase):
    pass

class ProfileUpdate(ProfileBase):
    pass

class ProfileResponse(ProfileBase):
    id: int
    user_id: int
    full_name: Optional[str] = None
    email: Optional[str] = None
    
    class Config:
        from_attributes = True
