from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.orm import relationship
from app.core.database import Base

class Profile(Base):
    __tablename__ = "profiles"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id"), unique=True)
    job_title = Column(String(100))
    phone = Column(String(50))
    website = Column(String(255))
    avatar_url = Column(String(255))
    
    # Relationships
    user = relationship("User", back_populates="profile")
