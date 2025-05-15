from pydantic import BaseModel
from typing import List, Optional, Union


# مدل‌های پایه
class AnimeBase(BaseModel):
    title: str


class UserBase(BaseModel):
    username: str

class TopUserBase(UserBase):
    username: str
    avg: Optional[Union[str, float]] = None


class UserAnimeBase(BaseModel):
    anime_id: Optional[Union[str, float]] = None
    anime_title: Optional[str] = None
    my_score: Optional[Union[str, float]] = None
    episodes: Optional[Union[str, float]] = None

class ActiveUsers(UserBase):
    username: str
    days: Optional[Union[str, float]] = None

# مدل‌های برای ساخت
class AnimeCreate(AnimeBase):
    anime_id: str


class UserCreate(UserBase):
    pass


class UserAnimeCreate(UserAnimeBase):
    anime_id: str
    username: str


# مدل‌های برای خروجی
class Anime(AnimeBase):
    anime_id: str

    class Config:
        orm_mode = True


class User(UserBase):
    stats_mean_score: Optional[str] = None
    user_watching: Optional[str] = None
    user_completed: Optional[str] = None

    class Config:
        orm_mode = True


class UserAnime(UserAnimeBase):
    id: int
    anime_id: str
    username: str

    class Config:
        orm_mode = True


class UserWithAnimes(User):
    watched_animes: List[UserAnime] = []

    class Config:
        orm_mode = True


class AnimeWithUsers(Anime):
    user_watches: List[UserAnime] = []

    class Config:
        orm_mode = True

#----------

class AnimeTop(Anime):
    anime_id: str
    title: Optional[str] = None
    score: Optional[Union[float, str]] = None
    episodes: Optional[Union[int, str]] = None


class AnimePop(BaseModel):
    genre: Optional[str] = None
    watches: Optional[Union[int, str]] = None


class UserSimilarBase(BaseModel):
    username: str
    similar_anime_count: Optional[Union[int, str]] = None


class AnimePostBase(BaseModel):
    anime_id: str
    episodes: Optional[Union[int, str]] = None