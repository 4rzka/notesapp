# NOTES APP

App for note taking using flutter and nodejs.

### Install dependencies

```
cd backend
npm install

```

### Run Server

```
npm run server
```

### .env example
```
NODE_ENV = development
PORT = 5000
MONGO_URI = mongodb+srv://user:pwd@youradress.mongodb.net/db
JWT_SECRET = 123456
JWT_EXPIRE = 30d

```


## API
Backend Rest API 
|   name| description  | parameter   | request type|
| ------------ | ------------ | ------------ | ------------ |
|   /api/users |  Create new user |  `name` `email` `password`| POST |
|   /api/users/login |  Authorize user |  `email` `password`| POST |
|   /api/users/me |  Get user data|  `email` | GET |
|   /api/notes |  Get all notes by user |  `id` | GET |
|   /api/notes |  Create new note |  `title` `content`  `tags` | POST |
|   /api/notes |  Update note |  `title` `content`  `tags` | PUT |
|   /api/notes |  Delete note |  `id` | DELETE |
|   /api/tags |  Get all tags by user |  `id` | GET |
|   /api/tags |  Create new tag |  `name` `notes` | POST |
|   /api/tags |  Update tag |  `name` `notes`  | PUT |
|   /api/tags |  Delete tag |  `id` | DELETE |




