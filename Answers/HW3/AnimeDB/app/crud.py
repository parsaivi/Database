from sqlalchemy import Integer, Date, Float, CHAR, String
from sqlalchemy.sql import func, cast
from sqlalchemy.orm import Session
from app import models
from app import schemas

# عملیات‌های کاربر
def get_user(db: Session, username: str):
    return db.query(models.UserList).filter(models.UserList.username == username).first()

def get_users(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.UserList).offset(skip).limit(limit).all()

def create_user(db: Session, user: schemas.UserCreate):
    db_user = models.UserList(**user.dict())
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

# عملیات‌های انیمه


def get_animes(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.AnimeList).offset(skip).limit(limit).all()

def create_anime(db: Session, anime: schemas.AnimeCreate):
    db_anime = models.AnimeList(**anime.dict())
    db.add(db_anime)
    db.commit()
    db.refresh(db_anime)
    return db_anime

# عملیات‌های ارتباط کاربر و انیمه
def get_user_animes(db: Session, username: str, skip: int = 0, limit: int = 100):
    return db.query(models.UserAnimeList).filter(
        models.UserAnimeList.username == username
    ).offset(skip).limit(limit).all()

def create_user_anime(db: Session, user_anime: schemas.UserAnimeCreate):
    db_user_anime = models.UserAnimeList(**user_anime.dict())
    db.add(db_user_anime)
    db.commit()
    db.refresh(db_user_anime)
    return db_user_anime

def update_user_anime(db: Session, user_anime_id: int, user_anime: schemas.UserAnimeBase):
    db_user_anime = db.query(models.UserAnimeList).filter(models.UserAnimeList.id == user_anime_id).first()
    for key, value in user_anime.dict().items():
        setattr(db_user_anime, key, value)
    db.commit()
    db.refresh(db_user_anime)
    return db_user_anime

def delete_user_anime(db: Session, user_anime_id: int):
    db_user_anime = db.query(models.UserAnimeList).filter(models.UserAnimeList.id == user_anime_id).first()
    db.delete(db_user_anime)
    db.commit()
    return db_user_anime


def get_anime_top(db):
    return db.query(models.AnimeList).order_by(cast(models.AnimeList.episodes, Integer).desc()).limit(10).all()


def get_anime_popular(db):
    return (db.query(
        models.AnimeList.genre.label("genre"),
        func.count(models.UserAnimeList.anime_id).label("watches"),
    ).join(models.AnimeList, models.AnimeList.anime_id == models.UserAnimeList.anime_id, isouter=True
    ).filter(models.AnimeList.genre.isnot(None)
    ).filter(models.AnimeList.genre != ""
    ).group_by(models.AnimeList.genre
    ).order_by(
        func.count(models.UserAnimeList.anime_id).desc()
    ).limit(3).all())


def get_top_users(db: Session, page: int, offset: int, year: int = None, gender: str = None):
    if not page:
        page = 1
    if not offset:
        offset = 10
    if not year:
        year = 2017
    if not gender:
        gen = "F"
    skip = (page - 1) * offset
    user_avg_score_sq = (
        db.query(
            models.UserAnimeList.username,
            func.avg(cast(models.UserAnimeList.my_score, Float)).label("avg")
        ).group_by(models.UserAnimeList.username).subquery()
    )

    return (
        db.query(
            models.UserList.username,
            user_avg_score_sq.c.avg.label("avg")
        ).join(
            user_avg_score_sq, models.UserList.username == user_avg_score_sq.c.username
        ).filter(
            user_avg_score_sq.c.avg > 8
        ).filter(
            func.substr(models.UserList.gender, 1, 1) == gender
        ).filter(
            cast(func.substr(models.UserList.join_date, 1, 4), Integer) > year
        ).order_by(
            user_avg_score_sq.c.avg.desc()
        ).offset(
            skip
        ).limit(
            offset
        ).all()
    )

def get_user_anime_watch(db, username, count):
    return (db.query(
        models.AnimeList.anime_id,
        models.AnimeList.title,
        models.UserAnimeList.my_score,
        models.AnimeList.episodes
    ).join(
        models.UserAnimeList, models.UserAnimeList.anime_id == models.AnimeList.anime_id
    ).filter(
        models.UserAnimeList.username == username
    ).group_by(
        models.AnimeList.anime_id,
        models.AnimeList.title,
        models.UserAnimeList.my_score,
        models.AnimeList.episodes
    ).order_by(
        models.UserAnimeList.my_score
    ).limit(
        count
    ).all())

def get_active_users(db, year):
    return (
        db.query(
            models.UserAnimeList.username.label("username"),
            func.sum(cast(models.UserAnimeList.my_watched_episodes, Integer)).label("days")
        )
        .filter(
            cast(func.substr(models.UserAnimeList.my_start_date, 1, 4), Integer) == year
        )
        .filter(
            cast(func.substr(models.UserAnimeList.my_finish_date, 1, 4), Integer) == year
        )
        .group_by(
            models.UserAnimeList.username
        )
        .order_by(
            func.sum(cast(models.UserAnimeList.my_watched_episodes, Integer)).desc()
        )
        .limit(5)
        .all()
    )


def get_similar_users(db, username):
    user_animes_sq = (
        db.query(
            models.UserAnimeList.anime_id
        ).filter(
            models.UserAnimeList.username == username
        ).subquery()
    )

    return (
        db.query(
            models.UserAnimeList.username,
            func.count(models.UserAnimeList.anime_id).label("count")
        ).join(
            user_animes_sq, user_animes_sq.c.anime_id == models.UserAnimeList.anime_id
        ).filter(
            models.UserAnimeList.username != username
        ).group_by(
            models.UserAnimeList.username
        ).order_by(
            func.count(models.UserAnimeList.anime_id).desc()
        ).limit(20).all()
    )


def update_anime_episodes(db, anime_id, value):
    anime = db.query(models.AnimeList).filter(models.AnimeList.anime_id == anime_id).first()
    if not anime:
        return None
    anime.episodes = str(int(value))
    db.commit()
    db.refresh(anime)
    return anime