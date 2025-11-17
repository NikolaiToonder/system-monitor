use qmetaobject::*;
use qmetaobject::prelude::*;

fn main() {
    let mut view = QQuickView::new();
    view.set_source("qml/main.qml".into());
    view.show();
    view.engine().exec();
}