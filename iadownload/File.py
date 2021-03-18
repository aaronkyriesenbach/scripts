class File:
    def __init__(self, url, metadata):
        self.url = url
        self.ia_file_name = url[url.rindex("/") + 1:]
        self.md5 = metadata.get("md5")
        
        self.format = self.ia_file_name[self.ia_file_name.rindex(".") + 1:]
        self.track_num = metadata.get("track")
        self.title = metadata.get("title")
        
        self.name = f"{self.track_num} - {self.title}.{self.format}"
        
    def __str__(self):
        return f"{self.url}: {self.name}"
