let style = document.createElement('style');
style.innerHTML = `html,
body{
    height: 100% !important;
}

.x-grid-panel{
    width: 100% !important;
}

.x-grid-panel .x-panel-body{
    width: 100% !important;
    overflow: auto !important;
}

.x-grid3-scroller{
    width: 100% !important;
}

.x-grid3-body{
    width: 100% !important;
}

.x-grid3-row{
    width: 100% !important;
}

.x-grid3-row-table{
    width: 100% !important;
}
.x-grid3-header-offset table,.x-grid3-header-offset {
    width: 100% !important
}

.x-grid3-cell{
    height: 40px !important;
    vertical-align: middle !important;
}

.x-grid3-row-checker, .x-grid3-hd-checker{
    width: 18px !important;
}

.x-grid3-col-checker{
    height: auto !important;
}

td.x-grid3-hd-over .x-grid3-hd-inner,
td.sort-desc .x-grid3-hd-inner,
td.sort-asc .x-grid3-hd-inner,
td.x-grid3-hd-menu-open .x-grid3-hd-inner{
    background-color: transparent !important;
    background-image: none !important;
}

.x-grid3-body .x-grid3-td-numberer,
.x-grid3-body .x-grid3-td-checker{
    background-image: none !important;
}
`;
document.head.appendChild(style);
