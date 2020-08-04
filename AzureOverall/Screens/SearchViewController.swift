//
//  BrowseViewController.swift
//  AzureOverall
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
  // MARK: - DiffableDataSource Enum
  enum Section {
    case main
  }
  
  //MARK: Private Properties and Initializers
  lazy var recipeSearchBar: UISearchBar = {
    let sb = UISearchBar()
    return sb
  }()
  
  lazy var recipeCollectionView: UICollectionView = {
    let cv = UICollectionView(frame: view.bounds, collectionViewLayout: configurePortraitLayout())
    cv.register(RecipeCell.self, forCellWithReuseIdentifier: RecipeCell.reuseIdentifier)
    cv.delegate = self
    cv.backgroundColor = .systemBackground
    return cv
  }()
  
  private var dataSource: UICollectionViewDiffableDataSource<Section, Recipe>?
  private var recipes = [Recipe]() {
    didSet {
      updateDataSource(with: recipes)
    }
  }
  
  
  // MARK: - Lifecyle Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    configureViewController()
    configureLayoutUI()
    configureDataSource()
    loadAllRecipesData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  
  //MARK: - Private Networking Methods
  private func loadAllRecipesData() {
    RecipeFetchingService.manager.getAllRecipes(from: "burger") { [weak self] (result) in
      guard let self = self else { return }
      DispatchQueue.main.async {
        switch result {
        case  let .success(fetchedRecipes):
          self.recipes = fetchedRecipes
        case .failure:
          let alertVC = UIAlertController(title: "Error",
                                          message: "An error fetching recipes occured. Your daily points limit of 150 has been reached.",
                                          preferredStyle: .alert)
          alertVC.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: nil))
          self.present(alertVC, animated:  true, completion: nil)
        }
      }
    }
  }
  
  
  // MARK: - Private Configuration Methods
  private func configurePortraitLayout() -> UICollectionViewCompositionalLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(0.9))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 0, trailing: 5)
    
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(250.0))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
    
    let section = NSCollectionLayoutSection(group: group)
    return UICollectionViewCompositionalLayout(section: section)
  }
  
  private func configureViewController() {
     view.backgroundColor = .systemBackground
    
    let addProfileButton = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: self, action: #selector(profileButtonTapped))
    navigationItem.rightBarButtonItem = addProfileButton
    navigationItem.title = ""
   }
  
  @objc func profileButtonTapped() {
    print("buttonTapped")
  }
  
  private func configureLayoutUI() {
    let itemViews = [recipeSearchBar, recipeCollectionView]
    
    for itemView in itemViews {
      view.addSubview(itemView)
      itemView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    NSLayoutConstraint.activate([
      recipeSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      recipeSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      recipeSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      
      recipeCollectionView.topAnchor.constraint(equalTo: recipeSearchBar.bottomAnchor),
      recipeCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      recipeCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      recipeCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  // MARK: - Private DiffableDataSource Methods
  private func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, Recipe>(collectionView: recipeCollectionView) { (collectionView, indexPath, recipe) -> UICollectionViewCell? in
      guard let cell = self.recipeCollectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.reuseIdentifier, for: indexPath) as? RecipeCell else {return UICollectionViewCell() }
      
      let cellData = self.recipes[indexPath.row]
      cell.recipeTitleLabel.text = cellData.title
      cell.prepTimeLabel.text = "\(cellData.readyInMinutes.description) Mins Prep"
      cell.servingsLabel.text = "For \(cellData.servings.description) People"
      
      
      ImageFetchingService.manager.downloadImage(from: cellData.id) { [weak self ](result) in
        guard let _ = self else { return }
        DispatchQueue.main.async {
          switch result {
          case let .success(image):
            cell.recipeImageView.image = image
          case let .failure(error):
            print(error)
          }
        }
      }
      return cell
    }
  }
  
  
  private func updateDataSource(with recipes: [Recipe]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Recipe>()
    snapshot.appendSections([.main])
    snapshot.appendItems(recipes)
    dataSource?.apply(snapshot, animatingDifferences: true)
  }
}


// MARK: - CollectionView Delegate
extension SearchViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let selectedRecipe = recipes[indexPath.row]
    let detailVC = DetailViewController()
    detailVC.recipe = selectedRecipe
    navigationController?.pushViewController(detailVC, animated: true)
  }
}
