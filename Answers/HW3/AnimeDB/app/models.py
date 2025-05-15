from sqlalchemy import Column, Integer, String, ForeignKey, Text, DateTime, Boolean
from sqlalchemy.orm import relationship
from datetime import datetime

from app.database import Base


class UserList(Base):
    __tablename__ = "user_list"

    username = Column(Text, primary_key=True, index=True)
    user_id = Column(Text, nullable=True)
    stats_rewatched = Column(Text, nullable=True)
    user_days_spent_watching = Column(Text, nullable=True)
    join_date = Column(Text, nullable=True)
    access_rank = Column(Text, nullable=True)
    last_online = Column(Text, nullable=True)
    stats_episodes = Column(Text, nullable=True)
    user_onhold = Column(Text, nullable=True)
    location = Column(Text, nullable=True)
    user_dropped = Column(Text, nullable=True)
    stats_mean_score = Column(Text, nullable=True)
    user_completed = Column(Text, nullable=True)
    user_plantowatch = Column(Text, nullable=True)
    birth_date = Column(Text, nullable=True)
    gender = Column(Text, nullable=True)
    user_watching = Column(Text, nullable=True)

    watched_animes = relationship("UserAnimeList", back_populates="user")

class AnimeList(Base):
    __tablename__ = "anime_list"

    anime_id = Column(Text, primary_key=True, index=True)
    studio = Column(Text, nullable=True)
    opening_theme = Column(Text, nullable=True)
    episodes = Column(Text, nullable=True)
    title_synonyms = Column(Text, nullable=True)
    licensor = Column(Text, nullable=True)
    score = Column(Text, nullable=True)
    related = Column(Text, nullable=True)
    aired = Column(Text, nullable=True)
    status = Column(Text, nullable=True)
    broadcast = Column(Text, nullable=True)
    rating = Column(Text, nullable=True)
    aired_string = Column(Text, nullable=True)
    type = Column(Text, nullable=True)
    popularity = Column(Text, nullable=True)
    favorites = Column(Text, nullable=True)
    rank = Column(Text, nullable=True)
    members = Column(Text, nullable=True)
    premiered = Column(Text, nullable=True)
    ending_theme = Column(Text, nullable=True)
    genre = Column(Text, nullable=True)
    duration = Column(Text, nullable=True)
    scored_by = Column(Text, nullable=True)
    title_english = Column(Text, nullable=True)
    image_url = Column(Text, nullable=True)
    airing = Column(Text, nullable=True)
    source = Column(Text, nullable=True)
    title_japanese = Column(Text, nullable=True)
    background = Column(Text, nullable=True)
    title = Column(Text, nullable=True)
    producer = Column(Text, nullable=True)

    user_watches = relationship("UserAnimeList", back_populates="anime")

class UserAnimeList(Base):
    __tablename__ = "user_anime_list"

    username = Column(Text, ForeignKey("user_list.username"))
    anime_id = Column(Text, ForeignKey("anime_list.anime_id"))
    id = Column(Integer, primary_key=True, index=True, autoincrement=True)
    username = Column(Text, ForeignKey("user_list.username"))
    anime_id = Column(Text, ForeignKey("anime_list.anime_id"))

    my_score = Column(Text, nullable=True)
    my_last_updated = Column(Text, nullable=True)
    my_start_date = Column(Text, nullable=True)
    my_rewatching = Column(Text, nullable=True)
    my_rewatching_ep = Column(Text, nullable=True)
    my_finish_date = Column(Text, nullable=True)
    my_watched_episodes = Column(Text, nullable=True)
    my_status = Column(Text, nullable=True)
    my_tags = Column(Text, nullable=True)

    user = relationship("UserList", back_populates="watched_animes")
    anime = relationship("AnimeList", back_populates="user_watches")
