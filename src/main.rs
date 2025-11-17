pub mod cpu_module;
pub mod system_instance;

use qmetaobject::*;
use crate::cpu_module::CpuMonitor;

fn main() {
    register_types();
    
    let mut view = QQuickView::new();
    view.set_source("qml/main.qml".into());
    view.show();
    view.engine().exec();
}

fn register_types() {
    qml_register_type::<CpuMonitor>(
        cstr::cstr!("SystemMonitor"),
        1, 0,
        cstr::cstr!("CpuMonitor")
    );
}