GulpControlView = require './gulp-control-view'
{CompositeDisposable} = require 'atom'

module.exports = GulpControl =
  modalPanel: null
  gulpView: null

  activate: (state) ->
    atom.workspaceView.command "gulp-control:toggle", => @toggle()

    this.newView()

    # Setup status bar icon
    # TODO: Fix this to whatever the new way is for adding a element to the statusbar
    #       since this throws a deprecated warning.
    # TODO: Replace GULP text with a image
    # TODO: Show some kind of mark if a task is running
    # TODO: If we have a watch running and hide the window, they show it again
    #       the text is no longer updating.
    @statusBar = atom.workspaceView.statusBar

    if @statusBar?
      # TODO: Create a view class for this
      @statusBarTile = document.createElement('div')
      @statusBarTile.textContent = "GULP"
      @statusBarTile.classList.add('inline-block')

      instance = this

      @statusBarTile.onclick = ->
        instance.toggle()

      @statusBar.appendRight(@statusBarTile)

    return

  deactivate: ->
    console.log 'GulpControl: deactivate'
    @modalPanel.destroy()
    @gulpView.destroy()
    @statusBarTile?.destroy()
    @statusBarTile = null
    return

  newView: ->
    @gulpView = new GulpControlView()
    @modalPanel = atom.workspace.addBottomPanel(item: @gulpView.getElement(), visible: true)

    return

  toggle: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
      @gulpView.clearGulpTasks()
      @gulpView.getGulpTasks()

  serialize: ->
