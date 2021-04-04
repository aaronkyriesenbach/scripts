class File:
    def __init__(self, url, metadata):
        self.url = url
        self.ia_base_name = url[url.rindex("/"):]
        self.ext = self.ia_base_name[self.ia_base_name.rindex(".") + 1:]
        self.md5 = metadata.get("md5")
        self.title = metadata.get("title")
        self.track_num = metadata.get("track")

    def __str__(self):
        return f"{self.url}: {self.get_file_name()}"

    def get_track_num(self):
        return str(self.track_num).zfill(2) if self.track_num and str(self.track_num).isdigit() and int(self.track_num) < 10 else str(self.track_num).replace("/", "_")

    def get_title(self):
        return self.title.replace("/", "_") if self.title else f"Track {self.get_track_num()}"
    
    def get_file_name(self):
        return f"{self.get_track_num()} - {self.get_title()}.{self.ext}"
