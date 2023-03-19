'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "assets/AssetManifest.json": "b462f9440b7960055b1041aef342fc19",
"assets/assets/google_fonts/Itim-Regular.ttf": "4a3f2cf1ced5257b6af803f4b86bf427",
"assets/assets/splash_screen/tocopedia_logo.png": "a752d2bdbb6c11fe57b60ecff2934e54",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "e7069dfd19b331be16bed984668fe080",
"assets/NOTICES": "4f7adbbf8e99212568bf4a5dfd8c7010",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"canvaskit/canvaskit.js": "97937cb4c2c2073c968525a3e08c86a3",
"canvaskit/canvaskit.wasm": "3de12d898ec208a5f31362cc00f09b9e",
"canvaskit/profiling/canvaskit.js": "c21852696bc1cc82e8894d851c01921a",
"canvaskit/profiling/canvaskit.wasm": "371bc4e204443b0d5e774d64a046eb99",
"favicon.png": "5a9f147f9ca7a6d9d7ac27b227a810ad",
"flutter.js": "a85fcf6324d3c4d3ae3be1ae4931e9c5",
"icons/Icon-192.png": "5be17307c1000a23b6bf363c6d6d716a",
"icons/Icon-512.png": "d2cc4f262c5c2a66aae53c78b249c993",
"icons/Icon-maskable-192.png": "5be17307c1000a23b6bf363c6d6d716a",
"icons/Icon-maskable-512.png": "d2cc4f262c5c2a66aae53c78b249c993",
"index.html": "571139f8e02a72b312994e41daf98594",
"/": "571139f8e02a72b312994e41daf98594",
"main.dart.js": "77cdffa50d35b32344547a55d747d9a8",
"manifest.json": "75051c797c2d8787013442a4ba61cecf",
"splash/img/branding-1x.png": "e980357ecdc738c4cbc0789f5d363ea5",
"splash/img/branding-2x.png": "8d08a6344112096f610c243509fb02d7",
"splash/img/branding-3x.png": "6c73ce0c50ab3a8201d58ff631f3e546",
"splash/img/branding-4x.png": "618c452eb31ff0cadacc1974e2c0f110",
"splash/img/branding-dark-1x.png": "e980357ecdc738c4cbc0789f5d363ea5",
"splash/img/branding-dark-2x.png": "8d08a6344112096f610c243509fb02d7",
"splash/img/branding-dark-3x.png": "6c73ce0c50ab3a8201d58ff631f3e546",
"splash/img/branding-dark-4x.png": "618c452eb31ff0cadacc1974e2c0f110",
"splash/img/dark-1x.png": "4a21c5c7c8db7f92eda8f0387b346d80",
"splash/img/dark-2x.png": "3e109f318d50699a2bd8eb854afbb951",
"splash/img/dark-3x.png": "21f80ece72b22495cacfef6c024509b3",
"splash/img/dark-4x.png": "cb24fe2f3c05f71583c0dffe44c6c044",
"splash/img/light-1x.png": "4a21c5c7c8db7f92eda8f0387b346d80",
"splash/img/light-2x.png": "3e109f318d50699a2bd8eb854afbb951",
"splash/img/light-3x.png": "21f80ece72b22495cacfef6c024509b3",
"splash/img/light-4x.png": "cb24fe2f3c05f71583c0dffe44c6c044",
"splash/splash.js": "123c400b58bea74c1305ca3ac966748d",
"splash/style.css": "ab6466886cd956c7b6c2d65417a4861e",
"version.json": "fc5dafbc4abbd36bab39d2da05dcd95e"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
