pub mod cpu_module;
pub mod memory_module;
pub mod system_instance;

use crate::cpu_module::CpuMonitor;
use crate::memory_module::MemoryMonitor;
use qmetaobject::*;

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
        1,
        0,
        cstr::cstr!("CpuMonitor"),
    );
    qml_register_type::<MemoryMonitor>(
        cstr::cstr!("SystemMonitor"),
        1,
        0,
        cstr::cstr!("MemoryMonitor"),
    );
}
