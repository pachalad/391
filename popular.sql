CREATE TABLE distinct_views (
   photo_id    int,
   user_id     varchar(24),
   PRIMARY KEY(photo_id, user_id),
   FOREIGN KEY(photo_id) REFERENCES images,
   FOREIGN KEY(user_id) REFERENCES users
);
