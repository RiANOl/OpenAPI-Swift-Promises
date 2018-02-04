import XCTest
import Promises
import KKBOXOpenAPISwift
@testable import KKBOXOpenAPISwiftPromises

class KKBOXOpenAPISwiftPromisesTests: XCTestCase {

	var API: KKBOXOpenAPI!

	override func setUp() {
		super.setUp()
		self.API = KKBOXOpenAPI(clientID: "5fd35360d795498b6ac424fc9cb38fe7", secret: "8bb68d0d1c2b483794ee1a978c9d0b5d")
	}

	//MARK: -

	func validate(track: KKTrackInfo) {
		XCTAssertNotNil(track)
		XCTAssertTrue(track.ID.count > 0)
		XCTAssertTrue(track.name.count > 0)
		XCTAssertTrue(track.duration > 0)
		XCTAssertNotNil(track.url)
		//		XCTAssertTrue(track.trackOrderInAlbum > 0)
		//		XCTAssertTrue(track.territoriesThatAvailableAt.count > 0)
		//		XCTAssertTrue(track.territoriesThatAvailableAt.contains(.taiwan))
		if let album = track.album {
			self.validate(album: album)
		}
	}

	func validate(album: KKAlbumInfo) {
		XCTAssertNotNil(album)
		XCTAssertTrue(album.ID.count > 0)
		XCTAssertTrue(album.name.count > 0)
		XCTAssertNotNil(album.url)
		XCTAssertTrue(album.images.count == 3)
		//		XCTAssertTrue(album.releaseDate?.count ?? 0 > 0)
		//		XCTAssertTrue(album.territoriesThatAvailanbleAt.count > 0, "\(album.name)")
		//		XCTAssertTrue(album.territoriesThatAvailanbleAt.contains(.taiwan))
		self.validate(artist: album.artist!)
	}

	func validate(artist: KKArtistInfo) {
		XCTAssertNotNil(artist)
		XCTAssertTrue(artist.ID.count > 0)
		XCTAssertTrue(artist.name.count > 0)
		XCTAssertNotNil(artist.url)
		XCTAssertTrue(artist.images.count == 2)
	}

	func validate(playlist: KKPlaylistInfo) {
		XCTAssertNotNil(playlist);
		XCTAssertTrue(playlist.ID.count > 0);
		XCTAssertTrue(playlist.title.count > 0);
		XCTAssertNotNil(playlist.url);
	}

	func validate(user: KKUserInfo) {
		XCTAssertTrue(user.ID.count > 0)
		XCTAssertTrue(user.name.count > 0)
		XCTAssertNotNil(user.url)
		XCTAssertNotNil(user.userDescription)
		XCTAssertTrue(user.images.count > 0)
	}

	//MARK: -

	func testFetchAccessToken() {
		let exp = self.expectation(description: "testFetchAccessToken")
		self.API.fetchAccessTokenByClientCredential().then { token in
			exp.fulfill()
		}.catch { error in
			XCTFail(error.localizedDescription)
			exp.fulfill()
		}
		self.wait(for: [exp], timeout: 3)
	}

	func testFetchWithInvalidCredential() {
		let exp = self.expectation(description: "testFetchWithInvalidCredential")
		self.API = KKBOXOpenAPI(clientID: "121321223123123", secret: "1231231321213")
		self.API.fetchAccessTokenByClientCredential().then { token in
			XCTFail("It's impossible!")
			exp.fulfill()
		}.catch { error in
			exp.fulfill()
		}
		self.wait(for: [exp], timeout: 3)
	}

	func testFetchTrack() {
		let exp = self.expectation(description: "testFetchAccessToken")
		self.API.fetchAccessTokenByClientCredential().then { token in
			return self.API.fetch(track: "4kxvr3wPWkaL9_y3o_")
		}.then { track in
			self.validate(track: track)
			exp.fulfill()
		}.catch { error in
			XCTFail(error.localizedDescription)
			exp.fulfill()
		}
		self.wait(for: [exp], timeout: 3)
	}

	func testFetchAlbum() {
		let exp = self.expectation(description: "testFetchAccessToken")
		self.API.fetchAccessTokenByClientCredential().then { token in
			return self.API.fetch(album: "WpTPGzNLeutVFHcFq6")
		}.then { album in
			self.validate(album: album)
			exp.fulfill()
		}.catch { error in
			XCTFail(error.localizedDescription)
			exp.fulfill()
		}
		self.wait(for: [exp], timeout: 3)
	}

	func testFetchInvalidAlbum() {
		let exp = self.expectation(description: "testFetchInvalidAlbum")
		self.API.fetchAccessTokenByClientCredential().then { token in
			return self.API.fetch(album: "WpTPGzNLeutVFHcFq6")
		}.then { album in
			self.validate(album: album)
			exp.fulfill()
		}.catch { error in
			XCTAssertTrue(error.localizedDescription == "Resource does not exist")
			exp.fulfill()
		}
		self.wait(for: [exp], timeout: 3)
	}

	func testFetchTracksInAlbum() {
		let exp = self.expectation(description: "testFetchTracksInAlbum")
		self.API.fetchAccessTokenByClientCredential().then { token in
			return self.API.fetch(tracksInAlbum: "WpTPGzNLeutVFHcFq6")
		}.then { tracks in
			for track in tracks.tracks {
				self.validate(track: track)
			}
			exp.fulfill()
		}.catch { error in
			XCTFail(error.localizedDescription)
			exp.fulfill()
		}
		self.wait(for: [exp], timeout: 3)
	}

	func testFetchTracksInInvalidAlbum() {
		let exp = self.expectation(description: "testFetchTracksInInvalidAlbum")
		self.API.fetchAccessTokenByClientCredential().then { token in
			return self.API.fetch(tracksInAlbum: "11111")
		}.then { tracks in
			XCTFail()
			exp.fulfill()
		}.catch { error in
			XCTAssertTrue(error.localizedDescription == "Resource does not exist")
			exp.fulfill()
		}
		self.wait(for: [exp], timeout: 3)
	}

	func testFetchArtist() {
		let exp = self.expectation(description: "testFetchArtist")
		self.API.fetchAccessTokenByClientCredential().then { token in
			return self.API.fetch(artist: "8q3_xzjl89Yakn_7GB")
		}.then { artist in
			self.validate(artist: artist)
			exp.fulfill()
		}.catch { error in
			XCTFail(error.localizedDescription)
			exp.fulfill()
		}
		self.wait(for: [exp], timeout: 3)
	}

	func testFetchAlbumsOfArtist() {
		let exp = self.expectation(description: "testFetchAlbumsOfArtist")
		self.API.fetchAccessTokenByClientCredential().then { token in
			return self.API.fetch(albumsBelongToArtist: "8q3_xzjl89Yakn_7GB")
		}.then { albums in
			for album in albums.albums {
				self.validate(album: album)
			}
			exp.fulfill()
		}.catch { error in
			XCTFail(error.localizedDescription)
			exp.fulfill()
		}
		self.wait(for: [exp], timeout: 3)
	}

	func testFetchTopTracksOfArtist() {
		let exp = self.expectation(description: "testFetchTopTracksOfArtist")
		self.API.fetchAccessTokenByClientCredential().then { token in
			return self.API.fetch(topTracksOfArtist: "8q3_xzjl89Yakn_7GB")
		}.then { tracks in
			for track in tracks.tracks {
				self.validate(track: track)
			}
			exp.fulfill()
		}.catch { error in
			XCTFail(error.localizedDescription)
			exp.fulfill()
		}
		self.wait(for: [exp], timeout: 3)
	}

	func testFetchRelatedArtists() {
		let exp = self.expectation(description: "testFetchRelatedArtists")
		self.API.fetchAccessTokenByClientCredential().then { token in
			return self.API.fetch(relatedArtistsOfArtist: "8q3_xzjl89Yakn_7GB")
		}.then { artists in
			for artist in artists.artists {
				self.validate(artist: artist)
			}
			exp.fulfill()
		}.catch { error in
			XCTFail(error.localizedDescription)
			exp.fulfill()
		}
		self.wait(for: [exp], timeout: 3)
	}

	func testFetchPlaylist() {
		let exp = self.expectation(description: "testFetchPlaylist")
		self.API.fetchAccessTokenByClientCredential().then { token in
			return self.API.fetch(playlist: "OsyceCHOw-NvK5j6Vo")
		}.then { playlist in
			self.validate(playlist: playlist)
			exp.fulfill()
		}.catch { error in
			XCTFail(error.localizedDescription)
			exp.fulfill()
		}
		self.wait(for: [exp], timeout: 3)
	}

	func testFetchTracksInPlaylist() {
		let exp = self.expectation(description: "testFetchTracksInPlaylist")
		self.API.fetchAccessTokenByClientCredential().then { token in
			return self.API.fetch(tracksInPlaylist: "OsyceCHOw-NvK5j6Vo")
		}.then { tracks in
			for track in tracks.tracks {
				self.validate(track: track)
			}
			exp.fulfill()
		}.catch { error in
			XCTFail(error.localizedDescription)
			exp.fulfill()
		}
		self.wait(for: [exp], timeout: 3)
	}

	func testFetchFeaturedPlaylists() {
		let exp = self.expectation(description: "testFetchFeaturedPlaylists")
		self.API.fetchAccessTokenByClientCredential().then { token in
			return self.API.fetchFeaturedPlaylists()
		}.then { playlists in
			for playlist in playlists.playlists {
				self.validate(playlist: playlist)
			}
			exp.fulfill()
		}.catch { error in
			XCTFail(error.localizedDescription)
			exp.fulfill()
		}
		self.wait(for: [exp], timeout: 3)
	}

	func testFetchNewHitsPlaylists() {
		let exp = self.expectation(description: "testFetchNewHitsPlaylists")
		self.API.fetchAccessTokenByClientCredential().then { token in
			return self.API.fetchNewHitsPlaylists()
		}.then { playlists in
			for playlist in playlists.playlists {
				self.validate(playlist: playlist)
			}
			exp.fulfill()
		}.catch { error in
			XCTFail(error.localizedDescription)
			exp.fulfill()
		}
		self.wait(for: [exp], timeout: 3)
	}

	func testFetchFeaturedPlaylistCategories() {
		let exp = self.expectation(description: "testFetchFeaturedPlaylistCategories")
		self.API.fetchAccessTokenByClientCredential().then { token in
			return self.API.fetchFeaturedPlaylistCategories()
		}.then { categoeries in
			for category in categoeries.categories {
				XCTAssertTrue(category.ID.count > 0)
				XCTAssertTrue(category.title.count > 0)
				XCTAssertTrue(category.images.count > 0)
			}
			exp.fulfill()
		}.catch { error in
			XCTFail(error.localizedDescription)
			exp.fulfill()
		}
		self.wait(for: [exp], timeout: 3)
	}

	func testFetchFeaturedPlaylistInCategory() {
		let exp = self.expectation(description: "testFetchFeaturedPlaylistInCategory")
		self.API.fetchAccessTokenByClientCredential().then { token in
			return self.API.fetchFeaturedPlaylist(inCategory: "CrBHGk1J1KEsQlPLoz")
		}.then { category in
			XCTAssertTrue(category.ID.count > 0)
			XCTAssertTrue(category.title.count > 0)
			XCTAssertTrue(category.images.count > 0)
			XCTAssertNotNil(category.playlists)
			if let playlists = category.playlists {
				for playlist in playlists.playlists {
					self.validate(playlist: playlist)
				}
			}
			exp.fulfill()
		}.catch { error in
			XCTFail(error.localizedDescription)
			exp.fulfill()
		}
		self.wait(for: [exp], timeout: 3)
	}


	static var allTests = [
		("testFetchAccessToken", testFetchAccessToken),
		("testFetchWithInvalidCredential", testFetchWithInvalidCredential),
		("testFetchTrack", testFetchTrack),
		("testFetchAlbum", testFetchAlbum),
		("testFetchArtist", testFetchArtist),
		("testFetchAlbumsOfArtist", testFetchAlbumsOfArtist),
		("testFetchTopTracksOfArtist", testFetchTopTracksOfArtist),
		("testFetchRelatedArtists", testFetchRelatedArtists),
		("testFetchPlaylist", testFetchPlaylist),
		("testFetchTracksInPlaylist", testFetchTracksInPlaylist),
		("testFetchFeaturedPlaylists", testFetchFeaturedPlaylists),
		("testFetchNewHitsPlaylists", testFetchNewHitsPlaylists),
		("testFetchFeaturedPlaylistCategories", testFetchFeaturedPlaylistCategories),
		("testFetchFeaturedPlaylistInCategory", testFetchFeaturedPlaylistInCategory),
		]
}
