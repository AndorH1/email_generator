from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api import auth, profile, templates, signatures
from app.core.config import settings

app = FastAPI(
    title="Email Signature Generator API",
    description="API for creating and managing email signatures",
    version="1.0.0"
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix="/api", tags=["Authentication"])
app.include_router(profile.router, prefix="/api", tags=["Profile"])
app.include_router(templates.router, prefix="/api", tags=["Templates"])
app.include_router(signatures.router, prefix="/api", tags=["Signatures"])

@app.get("/")
async def root():
    return {"message": "Email Signature Generator API", "version": "1.0.0"}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}
