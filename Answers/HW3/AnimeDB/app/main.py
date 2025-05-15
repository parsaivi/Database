from fastapi import Depends, FastAPI, HTTPException, Query, Path
from sqlalchemy.orm import Session
from typing import List

from . import crud, models, schemas
from .database import engine, get_db

models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="AnimeAPI", description="API for managing anime and user data")


@app.get("/animes/top", response_model=List[schemas.AnimeTop])
def get_anime_top(db: Session = Depends(get_db)):
    top_animes = crud.get_anime_top(db)
    if not top_animes:
        raise HTTPException(status_code=404, detail="No top animes found")
    result = []
    for anime in top_animes:
        result.append(schemas.AnimeTop(
            anime_id=anime.anime_id,
            title=anime.title,
            score=anime.score,
            episodes=anime.episodes
        ))
    return result

@app.get("/animes/popular", response_model=List[schemas.AnimePop])
def get_anime_popular(db: Session = Depends(get_db)):
    popular_animes = crud.get_anime_popular(db)
    if not popular_animes:
        raise HTTPException(status_code=404, detail="No popular animes found")
    result = []
    for anime in popular_animes:
        result.append(schemas.AnimePop(
            genre=anime.genre,
            watches=anime.watches
        ))
    return result

@app.get("/users/top", response_model=List[schemas.TopUserBase])
def get_top_users(page: int = Query(1, ge=1), offset: int = Query(10, ge=1, le=100), year: int = Query(2017), gender: str = Query("F"), db: Session = Depends(get_db)):
    top_users = crud.get_top_users(db, page, offset, year, gender)
    if not top_users:
        raise HTTPException(status_code=404, detail="No top users found")
    result = []
    for user in top_users:
        result.append(schemas.TopUserBase(
            username=user.username,
            avg=user.avg
        ))
    return result

@app.get("/users/{username}/watched", response_model=List[schemas.UserAnimeBase])
def get_users_anime(username: str = Path(...), count: int = Query(10, ge=1), db: Session = Depends(get_db)):
    user_anime_watched = crud.get_user_anime_watch(db, username, count)
    if not user_anime_watched:
        raise HTTPException(status_code=404, detail="User doesnt watch any anime")
    result = []
    for anime in user_anime_watched:
        result.append(schemas.UserAnimeBase(
            anime_id=anime.anime_id,
            anime_title=anime.title,
            my_score=anime.my_score,
            episodes=anime.episodes
        ))
    return result

@app.get("/users/active/{year}", response_model=List[schemas.ActiveUsers])
def get_active_users(db: Session = Depends(get_db), year: int = Path(...)):
    users = crud.get_active_users(db, year)
    if not users:
        raise HTTPException(status_code=404, detail="not found")
    result = []
    for user in users:
        result.append(schemas.ActiveUsers(
            username=user.username,
            days=user.days
        ))
    return result


@app.get("/users/{username}/similars", response_model=List[schemas.UserSimilarBase])
def get_similar_users(username: str = Path(...), db: Session = Depends(get_db)):
    similar_users = crud.get_similar_users(db, username)
    if not similar_users:
        raise HTTPException(status_code=404, detail="not found")
    result = []
    for user in similar_users:
        result.append(schemas.UserSimilarBase(
            username=user.username,
            similar_anime_count=user.count
        ))
    return result

@app.post("/anime/{anime_id}/episodes", response_model=schemas.AnimePostBase)
def update_anime_episodes(
    anime_id: str,
    value: int = Query(1, ge=1),
    db: Session = Depends(get_db)
):
    anime = crud.update_anime_episodes(db, anime_id, value)
    if not anime:
        raise HTTPException(status_code=404, detail="Anime not found")
    return schemas.AnimePostBase(
        anime_id=anime.anime_id,
        episodes=anime.episodes
    )


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)