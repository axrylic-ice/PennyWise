CREATE TABLE `user_imports` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`object_key` text NOT NULL,
	`file_name` text NOT NULL,
	`mime` text NOT NULL,
	`size` integer NOT NULL,
	`kind` text NOT NULL,
	`status` text NOT NULL,
	`parsed` text,
	`created_at` text NOT NULL
);
--> statement-breakpoint
CREATE INDEX `import_owner_idx` ON `user_imports` (`user_id`);--> statement-breakpoint
CREATE TABLE `user_scenarios` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`title` text NOT NULL,
	`data` text NOT NULL,
	`created_at` text NOT NULL,
	`updated_at` text NOT NULL
);
--> statement-breakpoint
CREATE INDEX `scenario_owner_idx` ON `user_scenarios` (`user_id`);--> statement-breakpoint
CREATE TABLE `user_workspaces` (
	`user_id` text PRIMARY KEY NOT NULL,
	`data` text NOT NULL,
	`version` integer DEFAULT 1 NOT NULL,
	`updated_at` text NOT NULL
);
