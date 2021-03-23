class File:
    def __init__(self, url, metadata, supported_extensions):
        self.metadata = metadata
        self.url = url
        self.ia_base_name = url[url.rindex("/"):]
        self.md5 = metadata.get("md5")

        self.supported_extensions = supported_extensions
        self.track_num = metadata.get("track")

    def __str__(self):
        return f"{self.url}: {self.get_base_name()}"

    def get_track_num(self):
        return str(self.track_num).zfill(2) if self.track_num else self.track_num

    def get_title(self):
        return self.metadata.get("title").replace("/", "_") if self.metadata.get(
            "title") else f"Track {self.get_track_num()}"
    
    def get_base_name(self):
        return f"{self.get_track_num()} - {self.get_title()}"
