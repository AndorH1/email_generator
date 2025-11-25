from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.api.dependencies import get_current_user, get_admin_user
from app.models.user import User
from app.models.template import Template
from app.schemas.template import TemplateResponse, TemplateCreate

router = APIRouter()

@router.get("/templates", response_model=List[TemplateResponse])
async def get_templates(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    templates = db.query(Template).filter(Template.is_public == True).all()
    return templates

@router.get("/templates/{template_id}", response_model=TemplateResponse)
async def get_template(
    template_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    template = db.query(Template).filter(Template.id == template_id).first()
    if not template:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Template not found"
        )
    return template

@router.post("/templates", response_model=TemplateResponse, status_code=status.HTTP_201_CREATED)
async def create_template(
    template_data: TemplateCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_admin_user)
):
    new_template = Template(**template_data.model_dump())
    db.add(new_template)
    db.commit()
    db.refresh(new_template)
    return new_template
