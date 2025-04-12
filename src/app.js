const express = require("express");
const path = require("path");
const bcrypt = require("bcryptjs");
const session=require("express-session");
const app = express();
require("./db/conn");
const User=require("./models/user");

const port = process.env.PORT || 3000;
const static_path=path.join(__dirname, '../public')

app.use(session({
  secret: "secretKey", // change this in production
  resave: false,
  saveUninitialized: true,
}));

app.use(express.urlencoded({ extended: false })); // for parsing form data
app.use(express.json());
app.use(express.static(static_path)); 
app.set("view engine","hbs");
app.get("/", (req, res) => {
  res.render("dashboard")
});
app.get("/signup",(req,res)=>{
  res.render("sign_up");
});
app.get("/login",(req,res)=>{
  res.render("login")
});
app.get("/user_dashboard",(req,res)=>{
  const user = req.session.user;
  if (!req.session.user) {
    return res.redirect("/login");
  }
  res.render("user_dashboard", { user: req.session.user });
});

app.post("/register", async(req,res)=>{
  try{
    const { name, email, password } = req.body;

    const newUser = new User({ name, email, password });
    await newUser.save();
    req.session.user = {
      name: newUser.name,
      id: newUser._id,
      email:newUser.email
    };

    res.status(201).redirect("/user_dashboard");

  }catch(error){
    console.log(error);
    res.status(400).send("Registration failed");
  }
});
app.post("/login",async(req,res)=>{
  const {email,password}=req.body;

try{
  const user = await User.findOne({ email:email.trim() });

  if (!user) {
    return res.status(400).send("User not found");
  }

  const isMatch = await bcrypt.compare(password, user.password);
  if (!isMatch) {
    return res.status(400).send("Invalid password");
  }

  
  req.session.user = {
    name: user.name,
    id: user._id,
    email: user.email,
  };

  res.redirect("/user_dashboard");

}catch(error){
  res.status(400).send(error)
}
});

app.listen(port, () => {
  console.log(`server is running at: http://localhost:${port}`);
  
});
