
[
  ["Avengers: Endgame", "avengers-end-game.png"],
  ["Captain Marvel", "captain-marvel.png"],
  ["Black Panther", "black-panther.png"],
  ["Avengers: Infinity War", "avengers-infinity-war.png"],
  ["Green Lantern", "green-lantern.png"],
  ["Fantastic Four", "fantastic-four.png"],
  ["Iron Man", "ironman.png"],
  ["Superman", "superman.png"],
  ["Spider-Man", "spiderman.png"],
  ["Batman", "batman.png"],
  ["Catwoman", "catwoman.png"],
  ["Wonder Woman", "wonder-woman.png"]
].each do |movie_title, file_name|
  movie = Movie.find_by!(title: movie_title)
  file = File.open(Rails.root.join("app/assets/images/#{file_name}"))
  movie.main_image.attach(io: file, filename: file_name)
end

Genre.create(name: "Action")
Genre.create(name: "Comedy")
Genre.create(name: "Drama")
Genre.create(name: "Romance")
Genre.create(name: "Thriller")
Genre.create(name: "Fantasy")
Genre.create(name: "Documentary")
Genre.create(name: "Adventure")
Genre.create(name: "Animation")
Genre.create(name: "Sci-Fi")

User.create!(name: 'James', email: 'james@testemail.com', password: 'password1!', username: 'jmitchell', admin: true)