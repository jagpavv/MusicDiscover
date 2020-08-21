# MusicDiscover
Discover your music!

First time using **RxSwift** and **RxCocoa**. :star_struck:


- [X] Learned RxSwift and RxCocoa,

- [x] Made MVVM structures (Model, view, viewModel
- Made Music models,
- Made API Searvice then checked it works well with Music models,
- Defined ViewModel input/output (Abstraction of the view),

- [x] Made Views
- UICollectionView
- UICollectionViewCell
- UISearchController

- [x] Binded View and ViewModel
- Fetch Musics
- Pagination
- SearchKeyword on UISearchController's searchBar
- UIActivityIndicatorView animation
- searched results shuffle

- [x] View settings
- Corner Radius or the item
- Navigation title
- SearchBar icon changing ( icon should display an activityIndicator while fetching )


This is the first time using RxSwift and RxCocoa. It was a really new way of seeing bind and data as a flow (sequence). It was a fun time to learn and use RxSwift and RxCocoa.

It was surprisingly simple that bind data (Music array) of the ViewModel to collectionview. :smile:

It is a little bit tricky making pagination and request up to 5. It took a long time to wrote calculating the last indexPath.item with music array and request the next page.

The result of Internet research on how to change the search bar icon was long and complex. If the results were the same, I thought it would be better to try another way. So I chose to wrap the view up to show the activity indicator, and implemented it in a few simple lines of code. (yeah!)
