//
//  MovieDetailViewController.swift
//  MobilliumiOSChallenge
//
//  Created by Hakan UNAL on 25.02.2021.
//

import UIKit
import JGProgressHUD
import Toaster

class MovieDetailViewController: UIViewController {

    public static var row : Int = -1
    public static var searchRow : Int = -1
    public static var nowPlayingRow : Int = -1
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imdbImageView: UIImageView!
    @IBOutlet weak var similarMoviesLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let hud = JGProgressHUD()
    
    var getMovie : GetMovie?
    
    var similarMovies : SearchMovies?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 128, height: 128)
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        
        collectionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: "CollectionViewCell")
        
        //let url = URL(string: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")
        //img.kf.setImage(with: url)
        
        hud.show(in: self.view)
        
        if MovieDetailViewController.searchRow != -1 {
            MoviesAPI.movieGet(movie_id: SearchViewController.searchMovies?.results?[MovieDetailViewController.searchRow].id) { [self] (response, error) in
                if response != nil
                {
                    self.hud.dismiss()
                    getMovie = response
                    
                    let url = URL(string: "https://image.tmdb.org/t/p/original/\(getMovie?.posterPath ?? "")")
                    img.kf.setImage(with: url)
                    
                    titleLabel.text = getMovie?.title
                    descriptionLabel.text = getMovie?.overview
                    starLabel.text = String(getMovie?.voteAverage ?? 0)
                    dateLabel.text = getMovie?.releaseDate?.toDate()?.toFormat("dd.MM.yyyy")
                    
                    hud.show(in: self.view)
                    
                    MoviesAPI.movieGetSimilar(movie_id: SearchViewController.searchMovies?.results?[MovieDetailViewController.searchRow].id) { (response, error) in
                        
                        if response != nil
                        {
                            self.hud.dismiss()
                            similarMovies = response
                            
                            collectionView.reloadData()
                        }
                        else
                        {
                            self.hud.dismiss()
                            Toast(text: error?.localizedDescription, duration: Delay.long).show()
                        }
                        
                        MovieDetailViewController.row = -1
                        MovieDetailViewController.searchRow = -1
                        MovieDetailViewController.nowPlayingRow = -1
                    }
                }
                else
                {
                    self.hud.dismiss()
                    Toast(text: error?.localizedDescription, duration: Delay.long).show()
                }
            }
        }
        else if MovieDetailViewController.row != -1 {
            MoviesAPI.movieGet(movie_id: ListViewController.upComingMovies?.results?[MovieDetailViewController.row].id) { [self] (response, error) in
                if response != nil
                {
                    self.hud.dismiss()
                    getMovie = response
                    
                    let url = URL(string: "https://image.tmdb.org/t/p/original/\(getMovie?.posterPath ?? "")")
                    img.kf.setImage(with: url)
                    
                    titleLabel.text = getMovie?.title
                    descriptionLabel.text = getMovie?.overview
                    starLabel.text = String(getMovie?.voteAverage ?? 0)
                    dateLabel.text = getMovie?.releaseDate?.toDate()?.toFormat("dd.MM.yyyy")
                    
                    hud.show(in: self.view)
                    
                    MoviesAPI.movieGetSimilar(movie_id: ListViewController.upComingMovies?.results?[MovieDetailViewController.row].id) { (response, error) in
                        
                        if response != nil
                        {
                            self.hud.dismiss()
                            similarMovies = response
                            
                            collectionView.reloadData()
                        }
                        else
                        {
                            self.hud.dismiss()
                            Toast(text: error?.localizedDescription, duration: Delay.long).show()
                        }
                        
                        MovieDetailViewController.row = -1
                        MovieDetailViewController.searchRow = -1
                        MovieDetailViewController.nowPlayingRow = -1
                    }
                }
                else
                {
                    self.hud.dismiss()
                    Toast(text: error?.localizedDescription, duration: Delay.long).show()
                }
            }
        }
        else {
            MoviesAPI.movieGet(movie_id: ListViewController.nowPlayingMovies?.results?[MovieDetailViewController.nowPlayingRow].id) { [self] (response, error) in
                if response != nil
                {
                    self.hud.dismiss()
                    getMovie = response
                    
                    let url = URL(string: "https://image.tmdb.org/t/p/original/\(getMovie?.posterPath ?? "")")
                    img.kf.setImage(with: url)
                    
                    titleLabel.text = getMovie?.title
                    descriptionLabel.text = getMovie?.overview
                    starLabel.text = String(getMovie?.voteAverage ?? 0)
                    dateLabel.text = getMovie?.releaseDate?.toDate()?.toFormat("dd.MM.yyyy")
                    
                    hud.show(in: self.view)
                    
                    MoviesAPI.movieGetSimilar(movie_id: ListViewController.nowPlayingMovies?.results?[MovieDetailViewController.nowPlayingRow].id) { (response, error) in
                        
                        if response != nil
                        {
                            self.hud.dismiss()
                            similarMovies = response
                            
                            collectionView.reloadData()
                        }
                        else
                        {
                            self.hud.dismiss()
                            Toast(text: error?.localizedDescription, duration: Delay.long).show()
                        }
                        
                        MovieDetailViewController.row = -1
                        MovieDetailViewController.searchRow = -1
                        MovieDetailViewController.nowPlayingRow = -1
                    }
                }
                else
                {
                    self.hud.dismiss()
                    Toast(text: error?.localizedDescription, duration: Delay.long).show()
                }
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return similarMovies?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        cell.moviesViewModel = similarMovies?.results?[indexPath.row]
        
        return cell
    }
}

extension MovieDetailViewController: UICollectionViewDelegate {

}

extension MovieDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 128, height: 128)
    }
}
