# Installation
1. `$ gem install dashing`
2. `$ gem install bundler`
3. `$ cd` (into repo)
4. `$ bundle`
5. `$ dashing start`

# Viewing a Dashboard
URL: `localhost:3030/nameofdashboard`

Drag widgets around to create new layouts once you are happy with a layout click the `Save this layout` button.

If your dashboard `.erb` already has a `<script>` tag at the top of the file just copy the line starting with `Dashing.gridsterLayout` and paste it within the function inside the `<script>` tag.

Otherwise copy and paste the code provided into your dashboard `.erb` file (starting on line 1)

# How stuff works

### Jobs
Things begin with the `/jobs` ruby files. These scripts will fetch data from whatever you define as the source. They will run however often you like as defined by `SCHEDULER.every '2m' do`. Anything after that line and before its `end` will run every `2m` (2 minutes). You could also use `2s` for 2 seconds. (at this time I am unsure if 2h would work for 2 hours)

Within the `SCHEDULER` there must be a `send_event` to send the data to a widget. For example, `send_event('github', { items: repo_issues.slice(0, 5) })` would send an event called `github` containing the array `repo_issues` sliced to the top 5 results only.

### Dashboards
Inside `/dashboards` are all of your dashboard `.erb`'s. These files determine which widgets should be displayed and where they should be positioned. Each `.erb` releates to a dashboard. (Except `layout.erb` leave him alone). 

Generally a `dashboard.erb` file will contain a `<script>` tag at the top for sizing & positioning widgets. `<% content_for(:title) { "My Dashboard" } %>` setting the page title (in this case to "My Dashboard").

Each widget is defined as a `<li>` in an `<ul>` within a `<div class='gridster'>` (class='gridster' is a requirement!). You can also set up the widget like this `<li data-row="1" data-col="1" data-sizex="2" data-sizey="1">` which will give us a widget in the first row and column that is 2 columns wide and 1 row high (leaving all widgets' data-col and row to 1 leaves the organizing to dashing).

Within the `<li data-row=…>` you place a `<div>`, this is where you hook your widget up to the data! A widget's `<div>` tag will usually look like this…

	<div data-id="github" data-view="List" data-title="My Github List"></div>
	
`data-id="github"` calls that array from the `send_event` earlier.

`data-view="List"` calls up a List widget to display the array data.

`data-title="My Github List"` sets the widgets title.

### Widgets
Inside `/widgets` are folders for each style of widget you can use. Inside each folder you will find an `.html` file, `.coffee` file and a `.scss` file. These three files determine what data is shown on a widget and what the widget looks like.

# Custom Widgets

### Current Custom Widgets
- 

# Reference
[Dashing Website](http://shopify.github.com/dashing) for more information.