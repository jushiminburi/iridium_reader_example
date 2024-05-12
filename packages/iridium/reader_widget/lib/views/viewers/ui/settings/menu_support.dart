class MenuSupports {
  static MenuSupports tableOfContent = MenuSupports('Mục lục', 0);
  static MenuSupports hightlightAndNote = MenuSupports(' Nổi bật/Chú thích', 1);
  static MenuSupports bookmarks = MenuSupports('Bookmarks', 2);
  static List<MenuSupports> values = [
    tableOfContent,
    bookmarks,
    hightlightAndNote,
  ];
  final String name;
  final int index;

  MenuSupports(this.name, this.index);
}
