const { json } = require("body-parser");
var express = require("express");
var request = require("request");
var mongoose = require("mongoose");
var app = express();
app.use(express.json());
// app.use(express.urlencoded());

mongoose.connect('mongodb+srv://vaishnavvom:vom12345@vom.mgw6dbt.mongodb.net/?retryWrites=true&w=majority');

const movieSchema = {
    movieId: String,
    title: String,
}

const Movie = mongoose.model("Movie", movieSchema);

//searchbar
app.get("/home/title/:mname", function(req, res){ 
    mname = req.params.mname
    request("https://api.themoviedb.org/3/search/movie?api_key=ab8c30463ed06a2663385616321f1f35&query="+mname, 
    function(error, response, body){
        data = JSON.parse(body);
        res.send(body);
        console.log(data);
    });
});

//popular-movies-per-week
app.get("/home/popular" , (req,res) => {
    request ("https://api.themoviedb.org/3/movie/popular?api_key=ab8c30463ed06a2663385616321f1f35&language=en-US&page=1", (error , response , body) =>{
        data = JSON.parse(body);
        res.send(body);
        console.log(data);
    })
})
//genre
app.get("/home/genre" , (req,res) => {
    request ("https://api.themoviedb.org/3/genre/movie/list?api_key=ab8c30463ed06a2663385616321f1f35&language=en-US", (error , response , body) =>{
        data = JSON.parse(body);
        res.send(body);
        console.log(data);
    })
})


app.get("/home/details/:id", function(req, res){ 
    id = req.params.id
    console.log(id);
    request("https://api.themoviedb.org/3/movie/" + id +"?api_key=ab8c30463ed06a2663385616321f1f35&language=en-US ",
    function(error, response, body){
        data = JSON.parse(body);
        res.send(body);
        console.log(data);
    });
});

app.post("/favorites/", function(req,res){
    const reqContent = req.body;
    console.log(reqContent)
    const movie = new Movie(reqContent)
    movie.save(function (err) {
        if (err) console.log(err);
    })
})
app.delete("/favorites/:movie", function(req,res){
    movietodel = req.params.movie
    Movie.findOneAndDelete({}, function (err, foundMovies) {
        if (err) {
            console.log(err);
        }
        else {
            res.json(foundMovies);
        }
    });
})



app.listen(3000, function() { 
    console.log('Server listening on port 3000'); 
  });