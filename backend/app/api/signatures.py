from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.responses import PlainTextResponse
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.api.dependencies import get_current_user
from app.models.user import User
from app.models.signature import Signature
from app.models.template import Template
from app.schemas.signature import SignatureResponse, SignatureCreate

router = APIRouter()

def render_template(template_html: str, data: dict) -> str:
    """Replace template placeholders with actual data"""
    rendered = template_html
    for key, value in data.items():
        placeholder = "{{" + key + "}}"
        rendered = rendered.replace(placeholder, str(value))
    return rendered

@router.post("/signatures", response_model=SignatureResponse, status_code=status.HTTP_201_CREATED)
async def create_signature(
    signature_data: SignatureCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Get template
    template = db.query(Template).filter(Template.id == signature_data.template_id).first()
    if not template:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Template not found"
        )
    
    # Render HTML
    html_rendered = render_template(template.html_template, signature_data.data)
    
    # Create signature
    new_signature = Signature(
        user_id=current_user.id,
        template_id=signature_data.template_id,
        data=signature_data.data,
        html_rendered=html_rendered
    )
    db.add(new_signature)
    db.commit()
    db.refresh(new_signature)
    return new_signature

@router.get("/signatures", response_model=List[SignatureResponse])
async def get_signatures(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    signatures = db.query(Signature).filter(Signature.user_id == current_user.id).all()
    return signatures

@router.get("/signatures/{signature_id}", response_model=SignatureResponse)
async def get_signature(
    signature_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    signature = db.query(Signature).filter(
        Signature.id == signature_id,
        Signature.user_id == current_user.id
    ).first()
    if not signature:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Signature not found"
        )
    return signature

@router.get("/signatures/{signature_id}/export", response_class=PlainTextResponse)
async def export_signature(
    signature_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    signature = db.query(Signature).filter(
        Signature.id == signature_id,
        Signature.user_id == current_user.id
    ).first()
    if not signature:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Signature not found"
        )
    return signature.html_rendered

@router.put("/signatures/{signature_id}", response_model=SignatureResponse)
async def update_signature(
    signature_id: int,
    signature_data: SignatureCreate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # Get existing signature
    signature = db.query(Signature).filter(
        Signature.id == signature_id,
        Signature.user_id == current_user.id
    ).first()
    if not signature:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Signature not found"
        )
    
    # Get template
    template = db.query(Template).filter(Template.id == signature_data.template_id).first()
    if not template:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Template not found"
        )
    
    # Render HTML
    html_rendered = render_template(template.html_template, signature_data.data)
    
    # Update signature
    signature.template_id = signature_data.template_id
    signature.data = signature_data.data
    signature.html_rendered = html_rendered
    
    db.commit()
    db.refresh(signature)
    return signature

@router.delete("/signatures/{signature_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_signature(
    signature_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    signature = db.query(Signature).filter(
        Signature.id == signature_id,
        Signature.user_id == current_user.id
    ).first()
    if not signature:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Signature not found"
        )
    db.delete(signature)
    db.commit()
    return None
