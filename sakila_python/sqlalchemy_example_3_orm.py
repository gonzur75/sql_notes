
from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, Session
engine = create_engine('sqlite:///yolo4.db', echo=True)

class Base(DeclarativeBase):
    pass

class User(Base):
    __tablename__ = 'user'

    # id = Column(Integer, primary_key=True)
    # name = Column(String, nullabe=False)
    # age = Column(Integer, nullable=False)

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str]
    age: Mapped[int]

Base.metadata.create_all(engine)

with Session(engine) as session:
    user = User(name='John', age=25)
    session.add(user)
    session.commit()

with Session(engine) as session:
    users = session.query(User).all()
    for user in users:
        print(user)