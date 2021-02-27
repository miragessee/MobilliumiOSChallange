//
//  ViewController.swift
//  MobilliumiOSChallenge
//
//  Created by Hakan UNAL on 25.02.2021.
//

import UIKit
import ImageSlideshow
import JGProgressHUD
import Toaster

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    let searchController = SearchViewController()
    
    @IBOutlet weak var slideshow: ImageSlideshow!
    
    let hud = JGProgressHUD()
    
    //let kingfisherSource = [KingfisherSource(urlString: "https://images.unsplash.com/photo-1432679963831-2dab49187847?w=1080")!, KingfisherSource(urlString: "https://images.unsplash.com/photo-1447746249824-4be4e1b76d66?w=1080")!, KingfisherSource(urlString: "https://images.unsplash.com/photo-1463595373836-6e0b0a8ee322?w=1080")!]
    
    var kingfisherSource = [KingfisherSource]()
    
    public static var nowPlayingMovies : Movies?
    public static var upComingMovies : Movies?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.delegate = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
        
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.white
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        
        slideshow.pageIndicator = pageControl
        slideshow.pageIndicatorPosition = .init(horizontal: .center, vertical: .bottom)
        
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.delegate = self
        
        //slideshow.setImageInputs(kingfisherSource)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ListViewController.didTap))
        slideshow.addGestureRecognizer(gestureRecognizer)
        
        SearchViewController.listViewController = self
        
        hud.show(in: self.view)
        
        MoviesAPI.now_playingGet() { [self] (response, error) in
            
            if response != nil
            {
                self.hud.dismiss()
                ListViewController.nowPlayingMovies = response
                titleLabel.text = ListViewController.nowPlayingMovies?.results?[0].title
                
                for items in response?.results ?? [] {
                    self.kingfisherSource.append(KingfisherSource(urlString: "https://image.tmdb.org/t/p/original/\(items.backdropPath ?? "")")!)
                }
                slideshow.setImageInputs(self.kingfisherSource)
            }
            else
            {
                self.hud.dismiss()
                Toast(text: error?.localizedDescription, duration: Delay.long).show()
            }
        }
        
        hud.show(in: self.view)
        
        MoviesAPI.upcomingGet() { [self] (response, error) in
            
            if response != nil
            {
                self.hud.dismiss()
                ListViewController.upComingMovies = response
                
                tableView.reloadData()
            }
            else
            {
                self.hud.dismiss()
                Toast(text: error?.localizedDescription, duration: Delay.long).show()
            }
        }
    }
    
    @objc func didTap() {
        MovieDetailViewController.nowPlayingRow = slideshow.currentPage
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
    
    public func show() {
        searchTableView.isHidden = false
        bg.isHidden = false
    }
    
    public func hide() {
        searchTableView.isHidden = true
        bg.isHidden = true
    }
    
    public func searchTableViewReloadData() {
        searchTableView.reloadData()
    }
}

extension ListViewController: ImageSlideshowDelegate {
    
    func imageSlideshow(_ imageSlideshow: ImageSlideshow, didChangeCurrentPageTo page: Int) {
        titleLabel.text = ListViewController.nowPlayingMovies?.results?[page].title
    }
}

// MARK: -
// MARK: UITableView Data Source
extension ListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return ListViewController.upComingMovies?.results?.count ?? 0
        } else {
            return SearchViewController.searchMovies?.results?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            let cell = Bundle.main.loadNibNamed("ListViewTableViewCell", owner: self, options: nil)?.first as! ListViewTableViewCell
            
            cell.moviesViewModel = ListViewController.upComingMovies?.results?[indexPath.row]
            
            cell.movieDetailButton.tag = indexPath.row
            cell.movieDetailButton.addTarget(self, action: #selector(movieDetailButtonClicked(sender:)), for: .touchUpInside)
            
            return cell
        } else {
            let cell = Bundle.main.loadNibNamed("SearchTableViewCell", owner: self, options: nil)?.first as! SearchTableViewCell
            
            cell.moviesViewModel = SearchViewController.searchMovies?.results?[indexPath.row]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    @objc func movieDetailButtonClicked(sender: UIButton) {
        let buttonRow = sender.tag
        print(buttonRow)
        MovieDetailViewController.row = buttonRow
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        self.navigationController?.pushViewController(nextViewController, animated:true)
    }
}

// MARK: -
// MARK: UITableView Delegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            
        } else {
            MovieDetailViewController.searchRow = indexPath.row
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
            self.navigationController?.pushViewController(nextViewController, animated:true)
        }
    }
}
