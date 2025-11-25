from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.api.dependencies import get_current_user
from app.models.user import User
from app.models.profile import Profile
from app.schemas.profile import ProfileResponse, ProfileUpdate

router = APIRouter()

@router.get("/profile", response_model=ProfileResponse)
async def get_profile(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    profile = db.query(Profile).filter(Profile.user_id == current_user.id).first()
    if not profile:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Profile not found"
        )
    
    # Add user data to response
    profile_dict = {
        "id": profile.id,
        "user_id": profile.user_id,
        "job_title": profile.job_title,
        "phone": profile.phone,
        "website": profile.website,
        "avatar_url": profile.avatar_url,
        "full_name": current_user.full_name,
        "email": current_user.email
    }
    return profile_dict

@router.put("/profile", response_model=ProfileResponse)
async def update_profile(
    profile_data: ProfileUpdate,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    profile = db.query(Profile).filter(Profile.user_id == current_user.id).first()
    if not profile:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Profile not found"
        )
    
    # Update profile fields
    for key, value in profile_data.model_dump(exclude_unset=True).items():
        setattr(profile, key, value)
    
    db.commit()
    db.refresh(profile)
    return profile
