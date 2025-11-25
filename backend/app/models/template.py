from sqlalchemy import Column, Integer, String, Text, Boolean
from sqlalchemy.orm import relationship
from app.core.database import Base

class Template(Base):
    __tablename__ = "templates"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    html_template = Column(Text, nullable=False)
    thumbnail_url = Column(String(255))
    is_public = Column(Boolean, default=True)
    
    # Relationships
    signatures = relationship("Signature", back_populates="template")
