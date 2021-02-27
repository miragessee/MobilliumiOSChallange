//
//  SearchViewController.swift
//  MobilliumiOSChallenge
//
//  Created by Hakan UNAL on 25.02.2021.
//

import UIKit
import JGProgressHUD
import Toaster

class SearchViewController: UISearchController {
    
    public static var listViewController : ListViewController?
    public static var searchMovies : SearchMovies?
    
    let hud = JGProgressHUD()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count >= 2 {
            
            hud.show(in: self.view)
            
            SearchAPI.searchMovieGet(query: searchText) { (response, error) in
                
                if response != nil
                {
                    self.hud.dismiss()
                    SearchViewController.searchMovies = response
                    
                    SearchViewController.listViewController?.searchTableViewReloadData()
                    
                    SearchViewController.listViewController?.show()
                }
                else
                {
                    self.hud.dismiss()
                    Toast(text: error?.localizedDescription, duration: Delay.long).show()
                }
            }
        } else {
            SearchViewController.listViewController?.hide()
        }
    }
}
