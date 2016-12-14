var CustomizationExperience = React.createClass({
  render: function(){
    return(
      <div className="customization-experience container-fluid">
        <MobileCustomizations />
        <DesktopCustomizations />
      </div>
    );
  }
})
