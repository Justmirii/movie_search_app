//
//  ViewController.swift
//  movie_search_app
//
//  Created by Mirmusa Feyziyev on 10.03.23.
//

import UIKit

// UI
// Network request
// tap a cell to see info about movie
// custom cell

class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var table: UITableView!
    @IBOutlet var field: UITextField!
    var movies = [Movie]()
    override func viewDidLoad() {
        super.viewDidLoad()
        table.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        field.delegate = self
    }
    // Field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovies()
        return true
    }
    func searchMovies() {
        field.resignFirstResponder()
        guard let text = field.text, !text.isEmpty else {
            return
        }
        let query = text.replacingOccurrences(of: " ", with: "%20")
        movies.removeAll()
        URLSession.shared.dataTask(with: URL(string: "https://www.omdbapi.com/?s=\(query)&apikey=e10d24c7")!,
                                   completionHandler: { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            // convert data
            var result: MovieResult?
            do {
                result = try JSONDecoder().decode(MovieResult.self, from: data)
            }
            catch {
                print("Error was occupied")
            }
            guard let finalResult = result else {
                return
            }
            // update our movies array
            let newMovies = finalResult.Search
            self.movies.append(contentsOf: newMovies)
            // refresh our table
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }).resume()
    }
    // Table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configure(with: movies[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // show movie details
        let url =   "https://www.imdb.com/title/\(movies[indexPath.row].imdbID)/"
    }
}
