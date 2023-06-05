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
|   /api/notes/:id |  Get all notes by user |  `id` | GET |
|   /api/notes |  Create new note |  `title` `content`  `tags` | POST |
|   /api/notes/:id |  Update note |  `title` `content`  `tags` | PUT |
|   /api/notes/:id |  Delete note |  `id` | DELETE |
|   /api/tags |  Get all tags by user |  `id` | GET |
|   /api/tags |  Create new tag |  `name` `notes` | POST |
|   /api/tags/:id |  Update tag |  `name` `notes`  | PUT |
|   /api/tags/:id |  Delete tag |  `id` | DELETE |
|   /api/todos |  Get all todos by user |  `id` | GET |
|   /api/todos/:id |  Get all todos by note |  `id` | GET |
|   /api/todos |  Create new todo |  `name` `notes` | POST |
|   /api/todos/:id |  Update todo |  `name` `notes`  | PUT |
|   /api/todos/:id |  Delete todo |  `id` | DELETE |
|   /api/contacts |  Get all contacts by user |  `id` | GET |
|   /api/contacts |  Create new contact |  `name` `notes` | POST |
|   /api/contacts/:id |  Update contact |  `name` `notes`  | PUT |
|   /api/contacts/:id |  Delete contact |  `id` | DELETE |

### TODO
## Backend
- [x] Notes CRUD
- [x] User CRUD
- [x] User Authentication JWT bcrypt
- [x] Tags
- [x] Todos
- [x] Contacts
- [x] Note Sharing
- [ ] Storing pictures, recordings etc
- [ ] Logout

## Flutter App
- [x] Notes homepage 
- [x] Note editpage
- [x] api-service for notes crud
- [x] User registration and login page
- [x] Adding / deleting tags
- [x] Search functionality
- [x] Sorting notes latest first
- [ ] Sorting notes by date, tags, contacts etc.
- [ ] Show notes on grid or list
- [x] Sidebar
- [ ] Todos
- [ ] Reminders
- [ ] Pictures
- [ ] Recordings
- [ ] Drawing
- [ ] Note background image/color
- [x] Contacts adding / importing from phone
- [ ] Linking contacts to notes
- [ ] Sharing notes with contacts / other users
- [ ] Setting page
- [ ] Speech to text
- [ ] Logout

### To be implemented/fixed next
- isChecked value is always false when creating todo
- ~~todos are not retrieved on frontend yet~~
- editing todos






